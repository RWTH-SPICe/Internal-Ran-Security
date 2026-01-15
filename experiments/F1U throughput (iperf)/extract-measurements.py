import sys
import statistics
import math

results_path = sys.argv[1]

ping_times = []

with open(results_path, "r") as file:
    lines = file.readlines()

for line in lines:
  ping_times.append(float(line.strip()))

z = statistics.NormalDist().inv_cdf((1 + .99) / 2.)

n = len(ping_times)
if n > 1:
  mean = statistics.mean(ping_times)
  stdev = statistics.stdev(ping_times)
  confidence = z * stdev / math.sqrt(n)
  ping_result = f"Results: {n=} mean={mean:.3f} stdev=±{stdev:.3f} 99%conf=±{confidence:.3f}"
else:
  mean = ping_times[0]
  ping_result = f"Results: {n=} {mean=}"
print(ping_result)

lines.insert(0, f"{ping_result}\n")
with open(results_path, "w") as file:
    file.writelines(lines)

print(f"results written to {results_path}")
