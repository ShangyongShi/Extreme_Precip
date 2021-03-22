## Wilks 1995. 

Page 65.

In particular, before embarking on the representation of data using theoretical functions, one must **decide among candidate distribution forms, fit parameters of the chosen distribution, and check that the resulting functions does, indeed, provide a reasonable fit. **All three of these steps require use of **real data**.  



### Gamma Distribution

Definition

- a physical limit on the left, positively skewed
- Function: 

$$
f(x)=\frac{(x/\beta)^{\alpha-1}exp(-x/\beta)}{\beta\Gamma(\alpha)},   x,\alpha,\beta>0.
$$

- $\alpha$, *shape parameter*; $\beta$, *scale parameter*.  
- the gamma function must be evaluate numerically or approximated using tabulated values.
- the mean of gamma distribution is $\alpha\beta$, the variance is $\alpha\beta^2$. Use the method of moments to estimate parameters:

$$
\alpha=\frac{\bar{x}^2}{s^2}\\
\beta=\frac{s^2}{\bar{x}}
$$

​		this is not bad for perhaps $\alpha>10$ but can give very bad results for small $\alpha$

- not analytically integrable. 

#### **Two approximations to the maximum likelihood estimators**

$$
A=ln(\bar{x})-\frac{1}{n}\sum_{i=1}^nln(x_i),
$$



##### Thom (1958)

$$
\hat\alpha=\frac{1+\sqrt{1+4A/3}}{4A},\\
\hat{\beta}=\frac{\bar{x}}{\hat{\alpha}}
$$

##### Greenwood and Durand, 1960

polynomial approximation.



standardize the test statistics by dividing by the scale parameter $\beta$.



### Goodness-of-Fit Tests

#### K-S Test (Kolmogorov-Smirnov)

comparing the empirical and theoretical CDFs for a single sample, under the null hypothesis that the observed data were drawn from the theoretical distribution. 

- the parameters have **not** been estimated from the data sample.  - applicable to any distributions.

- > Estimating the distribution parameters from the same batch of data used to test the goodness of fit results in the particular fitted distribution parameters being "turned" to the data sample. When erroneously using K-S tables that assume independence between the test data and the estimated parameters it will often be the case that the null hypothesis {that the distribution fits well} will not be rejected when in fact it should be.

#### $\chi^2$ Test

Compare the data histogram with the probability distribution (discrete) or density function (continuous)  

- less sensitive to discrepancies in the extreme tails than is the K-S test.
- operates more naturally for **discrete random variables.**

Function:
$$
\chi^2=\sum_{classes}\frac{(nd\_observd - nd\_expected)^2}{nd\_expected}\\
= \sum_{classes}\frac{(nd\_observd - n Pr\{data\ in\ class\})^2}{n Pr\{data\ in\ class\}}
$$
nd: the umber of data values "expected" to occur, according to the fitted distribution.

n*Pr: the probability of occurrence in that class times the sample size, n. 

- Not necessarily to be of equal width or equal probability, but classes with small numbers of expected counts should be avoided. Sometimes a minimum of five "expected" events per class is imposed.

- the test statistic follows the $\chi^2$ distribution with degrees of freedom:

$$
\nu=(number\ of\ classes)\ -\ (number\ of\ parameters\ fit)\ -\ 1
$$

