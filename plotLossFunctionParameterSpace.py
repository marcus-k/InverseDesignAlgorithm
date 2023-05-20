import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

# Import data
SSR_list, ff_list = [], []
for file in Path("data").glob("SSR-ff-data-offset-*.txt"):
    SSR, ff = np.loadtxt(file)
    SSR_list.append(SSR)
    ff_list.append(ff)

# Convert to numpy arrays
SSR_list = np.array(SSR_list).flatten()
ff_list = np.array(ff_list).flatten()

# Sort data by fill factor
idx = np.argsort(ff_list)
SSR_list = SSR_list[idx]
ff_list = ff_list[idx]

# Plot data
fontsize = 15
fig, ax = plt.subplots(figsize=(8, 4))
ax.tick_params(labelsize=fontsize)

ax.plot(ff_list, SSR_list, "-", ms=2)
ax.set_xlabel("Fill Factor", fontsize=fontsize)
ax.set_ylabel("Normalized SSR", fontsize=fontsize)
ax.grid(alpha=0.5)

# Save figure
fig.tight_layout()
fig.savefig("figures/SSR-vs-ff.png", dpi=300)

plt.show()