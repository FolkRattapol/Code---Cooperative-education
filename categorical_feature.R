## categorical feature
prep$GENDER <- factor(prep$GENDER, 
                      levels = c(0,1,2,3),
                      labels = c("Undefined", "Male", "Female","Other"))

prep$MARITAL_STATUS <- factor(prep$MARITAL_STATUS, 
                              levels = c(0,1,2),
                              labels = c("Undefined", "Married", "Single"))

prep$OCCUPATION <- factor(prep$OCCUPATION, 
                          levels = c(0,1,2,3,4,5,6,7,8),
                          labels = c("Undefined", 
                                     "Private Company",
                                     "Independent",
                                     "Government",
                                     "Business Owner","Other",
                                     "Temporary Worker",
                                     "State Enterpise",
                                     "Housewife"))

prep$OFFICE_SECTOR <- factor(prep$OFFICE_SECTOR, 
                             levels = c(0,1,2,3,4,5,6),
                             labels = c("Undefined",
                                        "Central",
                                        "Eastern",
                                        "Northeastern",
                                        "Northern",
                                        "Western",
                                        "Southern"))

## numerical into categorical feature
prep$AGE <- factor(prep$AGE, 
                   levels = c(1, 2, 3, 4),
                   labels = c("20-35",
                              "36-44",
                              "45-54",
                              "more than 54"))

prep$PRINCIPLE <- factor(prep$PRINCIPLE, 
                         levels = c(1,2,3,4), 
                         labels = c("0 - 10,000",
                                    "10,001 - 20,000",
                                    "20,001 - 30,000",
                                    "more than 30,000"))

prep$INTEREST <- factor(prep$INTEREST, levels = c(1,2,3,4),
                        labels = c("0 - 2,000",
                                   "2,001 - 4,000",
                                   "4,001 - 6,000",
                                   "more than 6,000"))

prep$TOTAL_OTHER_FEE <- factor(prep$TOTAL_OTHER_FEE, 
                               levels = c(1,2,3,4),
                               labels = c("0 - 2,000",
                                          "2,001 - 4,000",
                                          "4,001 - 6,000",
                                          "more than 6,000"))

prep$OS_BALANCE <- factor(prep$OS_BALANCE, 
                          levels = c(1,2,3,4), 
                          labels = c("0 - 10,000",
                                     "10,001 - 20,000",
                                     "20,001 - 30,000",
                                     "more than 30,000"))

prep$PMMONTHS_BK <- factor(prep$PMMONTHS_BK, 
                           levels = c(1,2,3,4,5,6,7,8),
                           labels = c("0-1",
                                      "2-3",
                                      "4-5",
                                      "7-12",
                                      "13-24",
                                      "25-60",
                                      "61-120",
                                      "more than 120"))
