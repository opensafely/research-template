# read compressed .csv file
df <- readr::read_csv("output/input.csv.gz")

# write a .feather file output
arrow::write_feather(df, "output/r.feather.lz4")
arrow::write_feather(df, "output/r.feather.raw", compression = "uncompressed")
arrow::write_feather(df, "output/r.feather.zstd", compression = "zstd")
