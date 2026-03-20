# ME8813_HW3_EugeneKIM-5.py

from pgmpy.models import BayesianNetwork
from pgmpy.factors.discrete import TabularCPD
from pgmpy.inference import VariableElimination
from pgmpy.inference import BeliefPropagation

# Define the Bayesian model
model = BayesianNetwork([('battery', 'juggling'), ('road', 'juggling'), ('juggling', 'report')])
cpd_battery = TabularCPD('battery', 2, [[0.95], [0.05]])
cpd_road = TabularCPD('road', 2, [[0.6], [0.4]])
cpd_juggling = TabularCPD(variable='juggling', 
                          variable_card = 2, 
                          evidence=['battery', 'road'],
                          evidence_card=[2, 2],
                          values=[[0.1, 0.9, 0.5, 0.3], [0.9, 0.1, 0.5, 0.7]])
cpd_report = TabularCPD(variable = 'report', 
                        variable_card = 2, 
                        evidence=['juggling'],
                        evidence_card=[2],
                        values = [[0.9, 0.1], [0.1, 0.9]]) 


# # Define the Bayesian network
# model = BayesianNetwork([('battery', 'juggling'), ('road', 'juggling'), ('juggling', 'report')])

# # Define the conditional probability distributions
# cpd_battery = TabularCPD(variable='battery', variable_card=2, values=[[0.95], [0.05]])
# cpd_road = TabularCPD(variable='road', variable_card=2, values=[[0.6], [0.4]])
# cpd_juggling = TabularCPD(variable='juggling', variable_card=2,
#                           evidence=['battery', 'road'],
#                           evidence_card=[2, 2],
#                           values=[[0.1, 0.9, 0.5, 0.3], [0.9, 0.1, 0.5, 0.7]])
# cpd_report = TabularCPD(variable='report', variable_card=2,
#                       evidence=['juggling'],
#                       evidence_card=[2],
#                       values=[[0.9, 0.1], [0.1, 0.9]])

model.add_cpds(cpd_battery, cpd_road, cpd_juggling, cpd_report)

# Perform exact inference
infer = VariableElimination(model)
posterior = infer.query(['battery'], evidence={'report': 0})

print('Exact Inference:')
print(posterior)

infer = BeliefPropagation(model)
posterior = infer.query(['battery'], evidence={'report': 1})
print('\nAPPROXIMATE PROPAGATION')
print(posterior)

# DISPLAY INDEPENDENCE
from pgmpy.independencies import Independencies # print independency relationships 
# Print the independencies
print('\nINDEPENDENCIES')
print(model.get_independencies())