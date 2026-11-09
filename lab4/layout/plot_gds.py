"""Ve anh layout tu file GDS (SKY130) bang gdstk + matplotlib.

Cach dung:  python plot_gds.py <cell> [rong_inch] [file.gds]
Ra file:    <cell>_layout.png
"""
import sys

import gdstk
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.patches import Patch, Polygon

# (layer, datatype): (ten, mau to, do trong suot, hatch, thu tu ve)
STYLE = {
    (64, 20): ("nwell",  "#f3e6a0", 0.45, "",     0),
    (65, 20): ("diff",   "#2ca02c", 0.45, "",     1),
    (65, 44): ("tap",    "#2ca02c", 0.30, "xx",   1),
    (66, 20): ("poly",   "#d62728", 0.60, "",     2),
    (66, 44): ("licon",  "#111111", 0.90, "",     5),
    (67, 20): ("li1",    "#1f77b4", 0.40, "",     3),
    (67, 44): ("mcon",   "#6a0dad", 0.90, "",     6),
    (68, 20): ("met1",   "#9467bd", 0.30, "//",   4),
    (68, 44): ("via1",   "#e377c2", 0.90, "",     7),
    (69, 20): ("met2",   "#ff7f0e", 0.30, "\\\\", 4.5),
}
LABEL_COLOR = {67: "#0b3d91", 68: "#4b0082", 69: "#b35900"}


def plot(cell, width_in=6.0, gds=None):
    lib = gdstk.read_gds(gds or f"{cell}.gds")
    top = [c for c in lib.cells if c.name == cell][0]
    polys = top.get_polygons()
    (x0, y0), (x1, y1) = top.bounding_box()
    h_in = width_in * (y1 - y0) / (x1 - x0)
    fig, ax = plt.subplots(figsize=(width_in + 2.2, max(h_in, 2.5)))
    used = set()
    for p in sorted(polys, key=lambda p: STYLE.get((p.layer, p.datatype), ("", "", 0, "", -1))[4]):
        st = STYLE.get((p.layer, p.datatype))
        if st is None:
            continue
        name, col, alpha, hatch, _ = st
        ax.add_patch(Polygon(p.points, closed=True, facecolor=col, alpha=alpha,
                             edgecolor=col, lw=0.6, hatch=hatch))
        used.add((p.layer, p.datatype))
    for lb in top.get_labels(depth=0):
        ax.text(lb.origin[0], lb.origin[1], lb.text, fontsize=9, fontweight="bold",
                ha="center", va="center", color=LABEL_COLOR.get(lb.layer, "k"),
                bbox=dict(fc="white", ec="none", alpha=0.7, pad=0.5))
    handles = [Patch(facecolor=STYLE[k][1], alpha=min(1, STYLE[k][2] + 0.2),
                     hatch=STYLE[k][3], label=STYLE[k][0])
               for k in sorted(used, key=lambda k: STYLE[k][4])]
    ax.legend(handles=handles, loc="upper left", bbox_to_anchor=(1.01, 1), fontsize=8)
    ax.set_xlim(x0 - 0.2, x1 + 0.2)
    ax.set_ylim(y0 - 0.2, y1 + 0.2)
    ax.set_aspect("equal")
    ax.set_xlabel("x (µm)")
    ax.set_ylabel("y (µm)")
    ax.set_title(f"Layout {cell} (SKY130)  -  {x1 - x0:.2f} x {y1 - y0:.2f} µm")
    ax.grid(alpha=0.15)
    fig.tight_layout()
    fig.savefig(f"{cell}_layout.png", dpi=200)
    print(f"-> {cell}_layout.png")


if __name__ == "__main__":
    # python plot_gds.py <cell> [rong_inch] [file.gds]
    plot(sys.argv[1], float(sys.argv[2]) if len(sys.argv) > 2 else 6.0,
         sys.argv[3] if len(sys.argv) > 3 else None)
