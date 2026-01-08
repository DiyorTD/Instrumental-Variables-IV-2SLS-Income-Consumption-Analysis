reg c y

reg y z


reg c yhat

reg c z
ivreg c (y = z)

reg c y
estimates store ols
ivreg c (y = z)
estimates store iv
hausman iv ols
