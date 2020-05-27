#### File Info ###############################
##
##  File_name : 0.process_mining_pm4py.R
##  Desc      : Description
##  Author    : GomGuard
##  Creted    : 2020-05-27
## 
##############################################
# doesn't work
# https://github.com/bupaverse/pm4py
# install.packages(c('pm4py', 'bupaR', 'DiagrammeR'))

library(pm4py)

# Most of the data structures are converted in their bupaR equivalents
library(bupaR)

# As Inductive Miner of PM4PY is not life-cycle aware, keep only `complete` events:
patients_completes <- patients[patients$registration_type == "complete", ]

# Discovery with Inductive Miner
pn <- discovery_inductive(patients_completes)

# This results in an auto-converted bupaR Petri net and markings
str(pn)
class(pn$petrinet)

# Render with bupaR
render_PN(pn$petrinet)

# Render with  PM4PY and DiagrammeR
library(DiagrammeR)
viz <- reticulate::import("pm4py.visualization.petrinet")

# Convert back to Python
py_pn <- r_to_py(pn$petrinet)
class(py_pn)

# Render to DOT with PMP4Y
dot <- viz$factory$apply(py_pn)$source
grViz(diagram = dot)

# Compute alignment
alignment <- conformance_alignment(patients_completes, pn$petrinet, pn$initial_marking, pn$final_marking)

# # Alignment is returned in long format as data frame
head(alignment)

# Evaluate model quality
quality <- evaluation_all(patients_completes, pn$petrinet, pn$initial_marking, pn$final_marking)