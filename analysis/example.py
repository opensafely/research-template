import pandas as pd
import pyarrow.feather

df = pd.read_csv("output/input.csv.gz")


# feather files are compressed by default in python
df.to_feather("output/python.feather.lz4")
pyarrow.feather.write_feather(df, "output/python.feather.raw", compression="uncompressed")
pyarrow.feather.write_feather(df, "output/python.feather.zstd", compression="zstd")
