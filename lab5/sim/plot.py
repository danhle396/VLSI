"""Lab 5 - Kiem tra chuc nang + ve do thi D flip-flop tu du lieu ngspice."""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.join("..", "results")
os.makedirs(OUT, exist_ok=True)
VDD, VTH = 1.8, 0.9
EDGES = [1, 3, 5, 7, 9, 11, 13, 15]          # ns, canh len cua clk


def save(fig, name):
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, name), dpi=150)
    plt.close(fig)
    print("  ->", os.path.join(OUT, name))


# ---- 1. Kiem tra chuc nang: q giua hai canh phai = d tai canh truoc ----
d = np.loadtxt("func_tran.dat")
t = d[:, 0] * 1e9
clk, dd, q, qb, m1, s1 = (d[:, k] for k in (1, 3, 5, 7, 9, 11))
print("\n  Canh(ns)  D@canh  Q mong doi  Q min..max trong chu ky   Ket qua")
ok_all = True
for k, e in enumerate(EDGES):
    dv = int(np.interp(e - 0.02, t, dd) > VTH)
    t_end = EDGES[k + 1] if k + 1 < len(EDGES) else 17
    m = (t > e + 0.3) & (t < t_end + 0.1)     # bo qua 300 ps sau canh (tcq)
    qmin, qmax = q[m].min(), q[m].max()
    ok = (qmin > VTH) if dv else (qmax < VTH)
    ok_all &= ok
    print(f"  {e:6d}     {dv}         {dv}        {qmin:6.3f} .. {qmax:6.3f}       {'PASS' if ok else 'FAIL'}")
print("  ==> CHUC NANG:", "DUNG" if ok_all else "SAI", "\n")

fig, ax = plt.subplots(5, 1, figsize=(11, 8), sharex=True)
for a, sig, name, c in ((ax[0], clk, "clk", "k"), (ax[1], dd, "d", "C0"),
                        (ax[2], m1, "master m1 (=d when clk=0)", "C4"),
                        (ax[3], s1, "slave s1 (=d')", "C5"), (ax[4], q, "q", "C2")):
    a.plot(t, sig, c, lw=1.4)
    a.set_ylabel(name, fontsize=8); a.set_ylim(-0.3, 2.1); a.grid(alpha=0.3)
    for e in EDGES:
        a.axvline(e, color="r", lw=0.6, ls=":")
ax[4].plot(t, qb, "C1", lw=1, alpha=0.6, label="qb"); ax[4].legend(loc="upper right", fontsize=8)
for x0, x1, txt in ((5.4, 5.8, "glitch\nclk=1"), (9.3, 9.6, "glitch\nclk=1"), (10.1, 10.3, "glitch\nclk=0")):
    ax[1].axvspan(x0, x1, color="orange", alpha=0.3)
    ax[1].text((x0 + x1) / 2, 2.0, txt, ha="center", va="top", fontsize=7)
ax[0].set_title("Positive-edge D flip-flop (TG master-slave, SKY130) - clk 500 MHz")
ax[4].set_xlabel("t (ns)")
save(fig, "lab5_func.png")

# ---- 2. Phong to tcq ----
fig, ax = plt.subplots(1, 2, figsize=(10, 3.8))
for a, e, ttl in ((ax[0], 1, "q rising (tcq_LH)"), (ax[1], 3, "q falling (tcq_HL)")):
    m = (t > e - 0.05) & (t < e + 0.35)
    a.plot((t[m] - e) * 1e3, clk[m], "k", label="clk")
    a.plot((t[m] - e) * 1e3, q[m], "C2", lw=2, label="q")
    a.plot((t[m] - e) * 1e3, s1[m], "C5", ls="--", label="s1")
    a.axhline(VTH, color="gray", ls=":")
    a.set(title=ttl, xlabel=f"t - {e} ns (ps)", ylabel="V"); a.grid(alpha=0.3); a.legend()
save(fig, "lab5_tcq.png")


# ---- 3. Setup / hold ----
def limit(fn, kind):
    """Gia tri ts/th nho nhat van dat (q dung va tcq <= 1.1 x tcq danh nghia)."""
    r = np.loadtxt(fn)
    nom = r[0, 1]
    ok = (r[:, 1] > 0) & (r[:, 1] <= 1.1 * nom)
    # quet tu lon xuong nho: lay diem dat cuoi cung truoc diem hong dau tien
    first_fail = np.argmax(~ok) if (~ok).any() else len(ok)
    return r, nom, r[first_fail - 1, 0]


fig, ax = plt.subplots(1, 2, figsize=(11, 4))
res = {}
for a, (kind, files) in zip(ax, (("setup", ("setup_r.dat", "setup_f.dat")),
                                 ("hold", ("hold_r.dat", "hold_f.dat")))):
    noms = []
    for fn, lbl in zip(files, ("capture 1 (d rising)", "capture 0 (d falling)")):
        r, nom, lim = limit(fn, kind)
        noms.append(nom)
        res[fn] = (nom, lim)
        good = r[:, 1] > 0
        a.plot(r[good, 0], r[good, 1], "o-", ms=4, label=f"{lbl}: {kind} = {lim:g} ps")
        a.axhline(1.1 * nom, color=a.lines[-1].get_color(), ls=":", lw=0.8)
    a.set(xlabel=("ts" if kind == "setup" else "th") + " (ps)", ylabel="tcq (ps)",
          title=f"{kind.upper()} time (criterion: tcq +10 %)")
    a.set_ylim(0.95 * min(noms), 1.35 * max(noms)); a.invert_xaxis(); a.grid(alpha=0.3); a.legend(fontsize=8)
save(fig, "lab5_setup_hold.png")

tsu = max(res["setup_r.dat"][1], res["setup_f.dat"][1])
thd = max(res["hold_r.dat"][1], res["hold_f.dat"][1])
print(f"  tcq danh nghia : LH = {res['setup_r.dat'][0]:.1f} ps, HL = {res['setup_f.dat'][0]:.1f} ps")
print(f"  Setup time     : d len {res['setup_r.dat'][1]:g} ps, d xuong {res['setup_f.dat'][1]:g} ps -> t_setup = {tsu:g} ps")
print(f"  Hold time      : d len {res['hold_r.dat'][1]:g} ps, d xuong {res['hold_f.dat'][1]:g} ps -> t_hold  = {thd:g} ps")
