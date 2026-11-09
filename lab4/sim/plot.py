"""Lab 4 - Ve do thi NAND tu du lieu ngspice (wrdata) ra thu muc ../results."""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = os.path.join("..", "results")
os.makedirs(OUT, exist_ok=True)
VDD = 1.8


def save(fig, name):
    fig.tight_layout()
    fig.savefig(os.path.join(OUT, name), dpi=150)
    plt.close(fig)
    print("  ->", os.path.join(OUT, name))


# ---- 1. VTC ba truong hop ----
d = np.loadtxt("vtc.dat")
vin = d[:, 0]
fig, ax = plt.subplots(figsize=(6.5, 4.5))
for col, lbl in ((1, "sweep a (b = 1)"), (3, "sweep b (a = 1)"), (5, "sweep a = b")):
    vo = d[:, col]
    vm = vin[np.argmin(abs(vo - vin))]
    ax.plot(vin, vo, lw=2, label=f"{lbl}, VM = {vm:.3f} V")
ax.plot(vin, vin, "k--", lw=0.8)
ax.set(xlabel="Vin (V)", ylabel="Vy (V)", title="VTC - CMOS NAND (SKY130, TT)", xlim=(0, VDD))
ax.grid(alpha=0.3); ax.legend(loc="lower left")
axin = ax.inset_axes([0.62, 0.55, 0.35, 0.4])
for col in (1, 3, 5):
    axin.plot(vin, d[:, col], lw=1.5)
axin.plot(vin, vin, "k--", lw=0.8)
axin.set(xlim=(0.7, 1.05), ylim=(0.6, 1.2)); axin.grid(alpha=0.3); axin.tick_params(labelsize=7)
save(fig, "lab4_vtc.png")

# ---- 2. Dang song transient + bang su that ----
d = np.loadtxt("tran.dat")
t, a, b, y, idd = d[:, 0] * 1e9, d[:, 1], d[:, 3], d[:, 5], -d[:, 7]
fig, ax = plt.subplots(4, 1, figsize=(10, 7), sharex=True)
for k, (sig, name, c) in enumerate(((a, "a", "C0"), (b, "b", "C1"), (y, "y = (a.b)'", "C2"))):
    ax[k].plot(t, sig, c, lw=1.5)
    ax[k].set_ylabel(name); ax[k].set_ylim(-0.3, 2.1); ax[k].grid(alpha=0.3)
ax[3].plot(t, idd * 1e6, "C3"); ax[3].set_ylabel("I(VDD) uA"); ax[3].grid(alpha=0.3)
ax[3].set_xlabel("t (ns)")
ax[0].set_title("Transient - CMOS NAND, CL = 10 fF")
tt = np.loadtxt("truth.dat")
ax[0].set_ylim(-0.3, 3.0)
for row in tt:
    ab = f"{int(row[1] > 0.9)}{int(row[2] > 0.9)}"
    ax[0].text(row[0] - 0.35, 2.5, f"ab={ab} y={int(row[3] > 0.9)}",
               ha="center", va="center", fontsize=7, color="dimgray")
save(fig, "lab4_tran.png")

# ---- 3. Phong to cac canh do tre ----
edges = [(2, "a rises (b=1): tpHL(a)"), (4, "b rises (a=1): tpHL(b)"), (7, "a, b rise together: tpHL(ab)"),
         (5, "a falls (b=1): tpLH(a)"), (3, "b falls (a=1): tpLH(b)"), (8, "a, b fall together: tpLH(ab)")]
fig, ax = plt.subplots(2, 3, figsize=(12, 6))
for axk, (t0, ttl) in zip(ax.flat, edges):
    m = (t >= t0 - 0.03) & (t <= t0 + 0.15)
    axk.plot((t[m] - t0) * 1e3, a[m], label="a"); axk.plot((t[m] - t0) * 1e3, b[m], "--", label="b")
    axk.plot((t[m] - t0) * 1e3, y[m], lw=2, label="y")
    axk.axhline(0.9, color="gray", ls=":")
    axk.set(title=ttl, xlabel=f"t - {t0} ns (ps)"); axk.grid(alpha=0.3)
ax[0, 0].legend()
save(fig, "lab4_tran_zoom.png")
