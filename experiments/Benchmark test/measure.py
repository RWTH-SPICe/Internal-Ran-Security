import os
import time
import csv
import numpy as np
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.hazmat.primitives import hashes, hmac
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.backends import default_backend

# --------------------------
# Configuration
# --------------------------
ITERATIONS = 20  # increased number of runs
CSV_FILE = "benchmark_results.csv"

# Original file sizes (bytes) from 128B to 1GB
FILE_SIZES = [
    1, 4, 16, 64, 256, 1024, 4096, 16384, 65536, 262144, 1048576, 4194304,
    16777216, 67108864, 268435456, 1073741824
]

# --------------------------
# Helper Functions
# --------------------------
def benchmark(func, data):
    """Run func ITERATIONS times and collect per-iteration throughput."""
    iteration_throughputs = []
    iteration_times = []
    for _ in range(ITERATIONS):
        start = time.perf_counter()
        func(data)
        end = time.perf_counter()
        elapsed = end - start
        iteration_times.append(elapsed)
        mb_per_sec = len(data)/(1024*1024)/elapsed
        iteration_throughputs.append(mb_per_sec)
    avg_time = np.mean(iteration_times)
    avg_throughput = np.mean(iteration_throughputs)
    return avg_time, avg_throughput, iteration_throughputs

# --------------------------
# Test Functions
# --------------------------
def gmac_aes128(data):
    key = os.urandom(16)
    iv = os.urandom(12)
    AESGCM(key).encrypt(iv, b"", data)

def hmac_sha256_128(data):
    key = os.urandom(16)
    h = hmac.HMAC(key, hashes.SHA256(), backend=default_backend())
    h.update(data)
    h.finalize()

def aes128_gcm(data):
    key = os.urandom(16)
    iv = os.urandom(12)
    AESGCM(key).encrypt(iv, data, None)

def aes256_gcm(data):
    key = os.urandom(32)
    iv = os.urandom(12)
    AESGCM(key).encrypt(iv, data, None)

def aes_cbc_hmac_sha256(data, key_size):
    key_enc = os.urandom(key_size)
    key_hmac = os.urandom(32)
    iv = os.urandom(16)
    cipher = Cipher(algorithms.AES(key_enc), modes.CBC(iv), backend=default_backend())
    encryptor = cipher.encryptor()
    pad_len = 16 - (len(data) % 16)
    padded = data + bytes([pad_len])*pad_len
    ciphertext = encryptor.update(padded) + encryptor.finalize()
    h = hmac.HMAC(key_hmac, hashes.SHA256(), backend=default_backend())
    h.update(ciphertext)
    h.finalize()

def aes128_cbc_hmac_sha256(data):
    aes_cbc_hmac_sha256(data, key_size=16)

def aes256_cbc_hmac_sha256(data):
    aes_cbc_hmac_sha256(data, key_size=32)

# --------------------------
# Algorithms to Test
# --------------------------
algorithms_to_test = [
    ("GMAC AES-128", gmac_aes128),
    ("HMAC-SHA256 128-bit key", hmac_sha256_128),
    ("AES-128-GCM", aes128_gcm),
    ("AES-256-GCM", aes256_gcm),
    ("AES-128-CBC + HMAC-SHA256", aes128_cbc_hmac_sha256),
    ("AES-256-CBC + HMAC-SHA256", aes256_cbc_hmac_sha256),
]

# --------------------------
# Run Benchmarks
# --------------------------
with open(CSV_FILE, "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["Algorithm", "File Size (Bytes)", "Iteration", "Time (s)", "Throughput (MB/s)"])

    for size in FILE_SIZES:
        print(f"\n=== Testing file size: {size} bytes ===")
        data = os.urandom(size)
        for label, func in algorithms_to_test:
            avg_time, avg_throughput, per_iter = benchmark(func, data)
            print(f"{label}: Avg Time = {avg_time:.6f}s, Avg Throughput = {avg_throughput:.2f} MB/s")
            for idx, tput in enumerate(per_iter):
                writer.writerow([label, size, idx+1, avg_time, tput])

print(f"\nBenchmark complete. Results saved to {CSV_FILE}")
