import pyshark
from datetime import timedelta
import sys
import statistics
import math

pcap_path = sys.argv[1]

pcap = pyshark.FileCapture(pcap_path)

latencies = []

ignore_current_iteration = False

iteration_start_time = None
registration_start_time = None

start_time = None

for packet in pcap:
  if 'F1AP' in packet:
    # UEContextSetupResponse
    if int(packet.F1AP.procedurecode) == 5:
      if hasattr(packet.F1AP, 'successfuloutcome_element'):
        if start_time is not None:
          total_time = (packet.sniff_time - start_time) / timedelta(milliseconds=1)
          latencies.append(total_time)
          start_time = None
    # PDUSessionResourceSetupRequest
  if 'NGAP' in packet:
    if int(packet.NGAP.procedurecode) == 29:
      if hasattr(packet.NGAP, 'initiatingmessage_element'):
        start_time = packet.sniff_time



z = statistics.NormalDist().inv_cdf((1 + .99) / 2.)

n = len(latencies)
if n > 1:
  mean = statistics.mean(latencies)
  stdev = statistics.stdev(latencies)
  confidence = z * stdev / math.sqrt(n)
  result = f"Results: {n=} mean={mean:.3f} stdev=±{stdev:.3f} 99%conf=±{confidence:.3f}"
else:
  mean = latencies[0]
  result = f"Results: {n=} {mean=}"
print(result)

pcap_path_wo_ending = ".".join(pcap_path.split(".")[:-1])
results_path = pcap_path_wo_ending+".txt"

lines = []

lines.insert(0, f"{result}\n")
for res in latencies:
  lines.append(f"{res}\n")
with open(results_path, "w") as file:
    file.writelines(lines)

print(f"results written to {results_path}")