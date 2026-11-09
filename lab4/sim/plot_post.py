"""Ve dang song PRE-layout vs POST-layout tu post_wave.dat (do tb_post.sp ghi ra).

Chay trong thu muc sim/:   python plot_post.py
Anh luu vao ../results/<lab>_post_wave.png
"""
import os
import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

LAB = os.path.basename(os.path.dirname(os.getcwd()))
# ten cac cot trong post_wave.dat (theo lenh wrdata trong tb_post.sp)
NAMES = {
    "lab3": (["in", "out_pre", "out_post"], [0.4e-9, 4.5e-9]),
    "lab4": (["a", "b", "y_pre", "y_post"], [0, 10e-9]),
    "lab5": (["clk", "d", "q_pre", "q_post"], [0, 17e-9]),
}
names, (t0, t1) = NAMES[LAB]

raw = np.loadtxt("post_wave.dat")
t = raw[:, 0]
sig = {n: raw[:, 2 * i + 1] for i, n in enumerate(names)}
inputs = [n for n in names if "pre" not in n and "post" not in n]
pre = [n for n in names if "pre" in n][0]
post = [n for n in names if "post" in n][0]

fig, ax = plt.subplots(len(inputs) + 1, 1, figsize=(11, 2.0 * (len(inputs) + 1) + 1), sharex=True)
for a, n in zip(ax, inputs):
    a.plot(t * 1e9, sig[n], "k", lw=1.2)
    a.set_ylabel(n + " (V)")
    a.grid(alpha=0.3)
a = ax[-1]
a.plot(t * 1e9, sig[pre], lw=1.6, label="pre-layout (schematic)")
a.plot(t * 1e9, sig[post], "--", lw=1.6, label="post-layout (layout + parasitic C)")
a.axhline(0.9, color="gray", ls=":", lw=0.8)
a.set_ylabel("output (V)")
a.set_xlabel("time (ns)")
a.legend(loc="upper right", fontsize=9)
a.grid(alpha=0.3)
ax[0].set_xlim(t0 * 1e9, t1 * 1e9)
fig.suptitle(f"{LAB.upper()} - pre-layout vs post-layout waveform (SKY130, TT)")
fig.tight_layout()
out = os.path.join("..", "results", f"{LAB}_post_wave.png")
fig.savefig(out, dpi=150)
print("  ->", out)
