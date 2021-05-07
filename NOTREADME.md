## 位点覆盖率统计

从 TCGA 拓展到一般数据位点覆盖率统计的核心思路。

### 核心思路

术语：`db` 已有的数据库，包含基因和突变位点等信息。`id` 基因-位点形式的唯一标识，如 `ATP13A2-p.L773L`。

1. 将数据梳理成可以使用的数据形式，通常包含两个文件，一个包含 `id` 信息，一个包含样本信息。
2. 将待统计数据中含 `db` 中的 `id`，注释为`覆盖`。
3. 输出数据作图。

### 流程

以 tcga 为例：

```R
library(tcga)

# 整理待统计数据 --------

# 指定位点数据中的需要读取的列，并命名为固定列名
index <- c(gene = "Hugo_Symbol", mutation = "HGVSp_Short", sample_id = "Tumor_Sample_Barcode")
# 以上三个为必要的字段，其他可以按需求添加

# 获得位点和对应样本 id 信息。
mua <- get_mua(data_path, index)

# 指定样本信息中的需要读取的列，并命名为固定的列名
index <- c(sample_id = "submitter_id", race = "race", stages = "tumor_stage")
# sample_id 为必要选项，race 和 stages 按需添加，其他按需添加 

# 获得样本信息
sample_info <- get_sample_info("data_path", index)

# step 2 ----------

df <- format_data(mua, db_path, sample_info, match = TRUE)
# TCGA 情况特殊需要，待统计的两个文件 sample id 需要配备，其他数据需改为 FALSE

# 获得覆盖率 --------
res <- get_ratio(df, na = TRUE, stages = TRUE, asian = FALSE)
# na 剔除无 stages 的数据，stages 分期数统计，asian 统计 race 中的亚洲人种

# 作图 ----------
ratio_plot(res)

```

### TCGA 按癌症种类读取

```R
uname <- unique(cancer_info$cancer_name)
tcga_path = 
maf_index =
csv_index =
db_path = 

out = list()
for (i in seq_along(uname)) {
    res <- merge_data(
        uname[i], tcga_path, maf_index, csv_index
    )
    res$cancer <- uname[i]
    out[[uname[i]]] <- res

    fwrite()
    
    get_ratio
    plot()

}
