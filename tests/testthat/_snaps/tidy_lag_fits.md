# produce tidy table of dlm model fit

    Code
      tidy_lag_fits(ex_dlm_cpred())
    Output
      # A tibble: 10 x 5
           lag estimate    se ci_lower ci_upper
         <int>    <dbl> <dbl>    <dbl>    <dbl>
       1     0    1.92  1.40    -0.817    4.65 
       2     1   -2.18  1.44    -5.00     0.648
       3     2   -0.185 1.36    -2.85     2.48 
       4     3    1.71  1.43    -1.10     4.51 
       5     4    1.25  1.57    -1.83     4.33 
       6     5    1.63  1.43    -1.18     4.44 
       7     6    2.40  1.36    -0.258    5.06 
       8     7   -2.26  1.39    -4.97     0.462
       9     8    0.952 1.37    -1.73     3.63 
      10     9   -1.49  0.936   -3.33     0.343

