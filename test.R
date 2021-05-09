library(tcga)
# tcga way
maf_index <- c(gene = "Hugo_Symbol", mutation = "HGVSp_Short", sample_id = "Tumor_Sample_Barcode")
csv_index <- c(sample_id = "submitter_id", race = "race", stages = "tumor_stage")

db_path <- "/Users/zhchy/projects/tcga/temp/20210317_TCGA_COSMIC_merge16Ex_raw_zero37_2.txt"

tcga_path <- "/Users/zhchy/new/push/data/TCGA_db/"

uname <- cancer_info$cancer_name

for (i in seq_along(uname)) {
    res <- merge_data(uname[i], tcga_path, maf_index, csv_index, db_path)
    res$cancer <- uname[i]
    fwrite(res, "tcga_info.tsv", sep = "\t", append = TRUE)
    res <- get_ratio(res, na = TRUE)
    res_asian <- get_ratio(res, na = TRUE, asian = TRUE)
    res <- cbind(res, res_asian)
    res$cancer = uname[i]
    fwrite(res, "tcga_ratio.tsv", sep = "\t", append = TRUE)
    # plot()
}

# 其他数据的模式

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