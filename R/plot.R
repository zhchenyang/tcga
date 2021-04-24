#' Plot the ratio
#'
#' @param mutations the data.frame
#' @param na omit.na
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' ratio_plot(df)
#' }
ratio_plot <- function(mutations, na = FALSE){
  if (na) mutations <- mutations[!is.na(stages)]

  mutations$stages <- forcats::fct_relevel(mutations$stages, "i", "ii", "iii", "iv", "v")
  out <- mutations[,
            .(n = sum(iscontain), N = .N),
            by = "stages"][order(stages)][     # TODO fixed order
              , ratio := cumsum(n)/cumsum(N)
            ]

  ggplot(data = out, aes(stages, ratio)) +
    geom_col(aes(stages, 1), width = .5, fill = "#afdfe4") +
    geom_col(aes(stages, ratio), width = .5, fill = "#00a6ac") +
    geom_label(
      aes(
        label = glue::glue("{round(ratio, 4) * 100}%({n}人)"),
        y = ratio + 0.03
      ),
      position = position_dodge(0.9),
      vjust = 0.9,
      size = 7
    ) +
    labs(y = NULL, x = NULL,
         title = NULL) +
    scale_y_continuous(labels = scales::percent) +
    coord_cartesian(expand = FALSE) +
    theme_minimal(base_size = 32) +
    theme(plot.title = element_text(hjust = .5))

}
