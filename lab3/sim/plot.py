"""Lab 3 - Ve do thi tu du lieu ngspice (wrdata) ra thu muc ../results."""
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


# ---- 1. VTC + do loi + dong ngan mach ----
d = np.loadtxt("vtc.dat")
vin, vout, gain, isc = d[:, 0], d[:, 1], d[:, 3], d[:, 5]
vm = vin[np.argmin(abs(vout - vin))]
idx = np.where(np.diff(np.sign(gain + 1)))[0]
vil, vih = vin[idx[0]], vin[idx[-1]]

fig, ax = plt.subplots(1, 2, figsize=(11, 4.2))
ax[0].plot(vin, vout, lw=2, label="Vout")
ax[0].plot(vin, vin, "k--", lw=0.8, label="Vout = Vin")
for v in (vil, vm, vih):
    ax[0].axvline(v, color="gray", ls=":")
ax[0].text(1.05, 1.2, f"VIL = {vil:.3f} V\nVM  = {vm:.3f} V\nVIH = {vih:.3f} V",
           fontsize=9, family="monospace", bbox=dict(fc="white", ec="gray"))
ax[0].set(xlabel="Vin (V)", ylabel="Vout (V)", title="VTC - CMOS Inverter (SKY130, TT)",
          xlim=(0, VDD), ylim=(-0.05, 1.95))
ax[0].grid(alpha=0.3); ax[0].legend(loc="center left")
ax2 = ax[0].twinx()
ax2.plot(vin, gain, "r", lw=1, alpha=0.6)
ax2.set_ylabel("dVout/dVin", color="r"); ax2.set_ylim(-14, 1)

ax[1].plot(vin, isc * 1e6, "g", lw=2)
ax[1].set(xlabel="Vin (V)", ylabel="I(VDD) (uA)", title="Supply current during switching")
ax[1].grid(alpha=0.3)
save(fig, "lab3_vtc.png")

# ---- 2. Dang song transient ----
d = np.loadtxt("tran.dat")
t, vi, vo, idd = d[:, 0] * 1e9, d[:, 1], d[:, 3], -d[:, 5]
fig, ax = plt.subplots(2, 1, figsize=(10, 5.5), sharex=True)
ax[0].plot(t, vi, label="in"); ax[0].plot(t, vo, label="out")
ax[0].axhline(0.9, color="gray", ls=":", lw=0.8)
ax[0].set(ylabel="V", title="Transient - CMOS Inverter, CL = 10 fF"); ax[0].legend(); ax[0].grid(alpha=0.3)
ax[1].plot(t, idd * 1e6, "g")
ax[1].set(xlabel="t (ns)", ylabel="I(VDD) (uA)"); ax[1].grid(alpha=0.3)
save(fig, "lab3_tran.png")

# ---- 3. Phong to 1 canh len / xuong ----
fig, ax = plt.subplots(1, 2, figsize=(10, 3.8))
for a, (t0, t1), ttl in ((ax[0], (0.45, 0.65), "Vin rising -> Vout falling (tpHL)"),
                         (ax[1], (1.45, 1.65), "Vin falling -> Vout rising (tpLH)")):
    m = (t >= t0) & (t <= t1)
    a.plot(t[m] * 1e3, vi[m], label="in"); a.plot(t[m] * 1e3, vo[m], label="out")
    a.axhline(0.9, color="gray", ls=":")
    a.set(xlabel="t (ps)", ylabel="V", title=ttl); a.grid(alpha=0.3); a.legend()
save(fig, "lab3_tran_zoom.png")

# ---- 4. Quet Wp ----
d = np.loadtxt("sizing.dat")
fig, ax = plt.subplots(1, 2, figsize=(10, 3.8))
ax[0].plot(d[:, 0], d[:, 1], "o-"); ax[0].axhline(0.9, color="gray", ls=":")
ax[0].set(xlabel="Wp (um), Wn = 1 um", ylabel="VM (V)", title="Switching threshold vs Wp"); ax[0].grid(alpha=0.3)
ax[1].plot(d[:, 0], d[:, 2], "o-", label="tpHL"); ax[1].plot(d[:, 0], d[:, 3], "s-", label="tpLH")
ax[1].set(xlabel="Wp (um), Wn = 1 um", ylabel="ps", title="Propagation delay vs Wp (CL = 10 fF)")
ax[1].grid(alpha=0.3); ax[1].legend()
save(fig, "lab3_sizing.png")

# ---- 5. Quet tai ----
d = np.loadtxt("load.dat")
fig, ax = plt.subplots(figsize=(5.5, 3.8))
ax.plot(d[:, 0], d[:, 1], "o-", label="tpHL"); ax.plot(d[:, 0], d[:, 2], "s-", label="tpLH")
ax.set(xlabel="CL (fF)", ylabel="ps", title="Propagation delay vs load CL"); ax.grid(alpha=0.3); ax.legend()
save(fig, "lab3_load.png")
