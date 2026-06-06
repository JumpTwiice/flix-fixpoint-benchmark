# flix-fixpoint-benchmark

Mini-benchmark of Flix's fixpoint module.

## Dataset

`data/road/road.csv` — California road network from [SNAP](https://snap.stanford.edu/data/roadNet-CA.html) consisting of almost 3 million bidirectional edges.

Run `sample()` to produce the sampled input file before benchmarking.


## Benchmark

```
python run_comparison.py
```

Runs the benchmark against each Flix version listed in `VERSIONS` and writes raw output to `results_v<version>.txt`.
