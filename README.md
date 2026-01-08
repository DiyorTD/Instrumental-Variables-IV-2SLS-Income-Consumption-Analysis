# Instrumental Variables (IV) & 2SLS: Income–Consumption Analysis

This repository contains a **step‑by‑step econometric analysis** demonstrating **endogeneity**, **Instrumental Variables (IV)**, **Two‑Stage Least Squares (2SLS)**, and the **Hausman test**, using a small teaching dataset.

The goal is to move from *correlation* to *causation* when estimating the effect of **income on consumption**.

---

## 📌 Research Question

> **Does income causally increase consumption, or does ordinary regression overstate this effect due to endogeneity?**

---

## Project Structure

```
├── data/
│   └── cyrect.dta          # Teaching dataset (37 observations)
├── dofiles/
│   └── analysis.do         # Stata do-file with all regressions
├── output/
│   └── regression_logs.txt # Saved regression output
└── README.md
```

---

##  Variables

| Variable | Description                                                  |
| -------- | ------------------------------------------------------------ |
| `c`      | Consumption (outcome variable)                               |
| `y`      | Income (endogenous regressor)                                |
| `z`      | Instrumental variable (exogenous source of income variation) |

---

##  Econometric Motivation

### Structural Model

We study the causal relationship:

$$
c_i = \alpha + \beta y_i + u_i
$$

where:

* $c_i$ = consumption
* $y_i$ = income (potentially endogenous)
* $u_i$ = unobserved shocks (preferences, expectations, ability)

The core problem is **endogeneity**:

$$
\mathbb{E}[y_i u_i] \neq 0
$$

which makes OLS biased.

---

In real life, **income is endogenous**:

* Unobserved optimism, ability, or expectations may increase both income and consumption
* Reverse causality and simultaneity are possible

This violates the OLS assumption:

```
E[y · u] = 0
```

As a result, **OLS estimates may be biased**.

---

## 🔹 Step 1: OLS (Baseline)

### Estimator

$$
\hat\beta_{OLS} = \frac{\sum (y_i-\bar y)(c_i-\bar c)}{\sum (y_i-\bar y)^2}
$$

### Variance and Standard Error

$$
\text{Var}(\hat\beta_{OLS}) = \frac{\hat\sigma^2}{\sum (y_i-\bar y)^2}, \quad
\hat\sigma^2 = \frac{RSS}{n-k}
$$

### Test Statistic

$$
t = \frac{\hat\beta_{OLS}}{SE(\hat\beta_{OLS})}
$$

### Result Interpretation

OLS shows a very strong relationship, but this may reflect correlation rather than causation.

---

```
reg c y
```

**Finding:**

* Strong positive relationship
* Very high R²

**Interpretation:**

* Income and consumption are highly correlated
* But causality is not guaranteed

---

## 🔹 Step 2: First Stage (Instrument Relevance)

### First-Stage Equation

$$
y_i = \pi_0 + \pi_1 z_i + v_i
$$

### F-statistic for Instrument Strength

$$
F = \frac{ESS/(k-1)}{RSS/(n-k)}
$$

Rule of thumb:

* $F \ge 10$ → strong instrument

In this project, the first-stage $F$ is very large, confirming strong relevance.

---

```
reg y z
```

**Finding:**

* Large coefficient on `z`
* F-statistic ≫ 10

**Conclusion:**

* Instrument is **strong** and relevant

---

## 🔹 Step 3: Reduced Form

```
reg c z
```

**Interpretation:**

* The instrument affects consumption indirectly through income

---

## 🔹 Step 4: Two-Stage Least Squares (2SLS)

### Stage 1: Predicted Income

$$
\hat y_i = \hat\pi_0 + \hat\pi_1 z_i
$$

### Stage 2: Structural Equation

$$
c_i = \alpha + \beta \hat y_i + \varepsilon_i
$$

### Closed-Form IV Estimator (Single Instrument)

$$
\hat\beta_{IV} = \frac{\text{Cov}(z,c)}{\text{Cov}(z,y)} = \frac{\hat\delta_1}{\hat\pi_1}
$$

where:

* $\hat\delta_1$ is from the reduced form $c$ on $z$
* $\hat\pi_1$ is from the first stage $y$ on $z$

---

```
ivreg c (y = z)
```

**What 2SLS does:**

1. Uses `z` to extract exogenous variation in income
2. Estimates the effect of that variation on consumption

**Result:**

* IV estimate is smaller than OLS
* Still highly statistically significant

---

## 🔹 Step 5: Hausman Test (Endogeneity Test)

### Hypotheses

$$
H_0: \mathbb{E}[y_i u_i] = 0 \quad (OLS\ consistent)
$$
$$
H_1: \mathbb{E}[y_i u_i] \neq 0
$$

### Test Statistic

$$
H = (\hat\beta_{IV} - \hat\beta_{OLS})'\left[\text{Var}(\hat\beta_{IV}) - \text{Var}(\hat\beta_{OLS})\right]^{-1}(\hat\beta_{IV} - \hat\beta_{OLS})
$$

Under $H_0$:

$$
H \sim \chi^2(q)
$$

Rejecting $H_0$ implies endogeneity and preference for IV.

---

```
estimates store ols
estimates store iv
hausman iv ols
```

**Null hypothesis:**

```
OLS is consistent (no endogeneity)
```

**Result:**

* Null rejected

**Conclusion:**

* Income is endogenous
* IV/2SLS should be preferred

---

##  Key Results Summary

| Estimator | Coefficient on Income | Interpretation                         |
| --------- | --------------------- | -------------------------------------- |
| OLS       | Higher                | Biased upward due to endogeneity       |
| IV / 2SLS | Lower                 | Causal effect of income on consumption |

---

## Economic Interpretation (Plain Language)

* People spend a large fraction of income increases
* Ordinary regression slightly **overstates** this effect
* When income rises for **exogenous reasons** (policy, shocks), consumption still rises — but less

---

##  What This Project Demonstrates

* Why **high R² ≠ causality**
* How **IV fixes endogeneity**
* The mechanics of **2SLS**
* Interpretation of **first-stage F-statistics**
* Proper use of the **Hausman test**

---

##  Intended Use

This repository is suitable for:

* Econometrics coursework
* Exam preparation (IV / Hausman)
* Teaching demonstrations
* Portfolio evidence of causal inference skills

---

## Tools

* **Stata** (reg, ivreg, hausman)
* Classical linear regression framework

---

##  Key Takeaway

> **Correlation is not causation. Instrumental Variables allow us to recover causal effects when regressors are endogenous.**

---

