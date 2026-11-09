"""Tao 2 netlist tu file PEX cua Magic de dung trong testbench post-layout.

  <cell>_post.spice : transistor + tu ky sinh   (subckt doi ten -> <ten>_post)
  <cell>_dev.spice  : chi transistor, bo tu      (subckt doi ten -> <ten>_dev)

Doi ten tat ca subckt (ke ca cell con nhu inv, tgate) de khong trung voi
netlist schematic khi include chung trong mot testbench.

Cach dung:  python make_post_netlists.py <cell>
"""
import re
import sys


def convert(lines, suffix, keep_caps):
    names = {m.group(1) for ln in lines if (m := re.match(r"\.subckt\s+(\S+)", ln, re.I))}
    out = []
    for ln in lines:
        tok = ln.split()
        if not tok:
            out.append(ln)
            continue
        if tok[0].lower() == ".subckt":
            tok[1] += suffix
            ln = " ".join(tok) + "\n"
        elif tok[0][0] in "Xx" and tok[-1] in names:
            # instance cua cell con (khong phai transistor, vi transistor co tham so w=/l=)
            tok[-1] += suffix
            ln = " ".join(tok) + "\n"
        elif tok[0][0] in "Cc" and not keep_caps:
            continue
        out.append(ln)
    return out


if __name__ == "__main__":
    cell = sys.argv[1]
    src = open(f"{cell}_pex.spice").readlines()
    open(f"{cell}_post.spice", "w", newline="\n").writelines(convert(src, "_post", True))
    open(f"{cell}_dev.spice", "w", newline="\n").writelines(convert(src, "_dev", False))
    ncap = sum(1 for ln in src if ln[:1] in "Cc")
    print(f"{cell}_post.spice ({ncap} tu ky sinh), {cell}_dev.spice (khong tu)")
