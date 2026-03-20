# research

MATLAB and Python analysis scripts from Georgia Tech coursework and BITN lab research.

## Structure

```
research/
├── matlab/
│   ├── ME4056-systems-lab/         # Thermal/mechanical systems lab (Fall 2022)
│   │   ├── blackbody-radiation/    # BBR calculations and curve fitting
│   │   ├── system-id-controls/     # PID gain calc, Simulink control scripts
│   │   ├── ic-engine/              # IC engine thermodynamic analysis
│   │   └── refrigeration/          # Refrigeration cycle analysis
│   ├── ME6105-modeling-simulation/ # Modeling & Simulation (HW1–8, Group Project)
│   │   ├── HW1–HW8/                # Individual homework scripts
│   │   └── group-project/          # ANOVA/regression on stress dataset
│   └── ME6407-robotics/            # Robotics (ME 6407)
│       ├── course-notes/           # Kinematics, dynamics, trajectory, controls
│       ├── HW2/                    # PUMA robot kinematics
│       ├── HW3/                    # Planar 3R inverse kinematics
│       └── HW4/                    # Planar 2R robot dynamics
├── ml-python/
│   └── ME8813/                     # ML for Mechanical Engineers (Spring 2023)
│       ├── HW1-optimization/       # Gradient descent optimization
│       ├── HW2-regression/         # Linear, Gaussian, Neural Network regression
│       ├── HW3-bayesian-network/   # Bayesian network inference
│       ├── HW4-dimensionality/     # PCA, autoencoders, GMM clustering
│       └── final-project-IMU/      # IMU motion classifier (KNN)
└── ien-research/
    └── data/                       # In-vitro implant experiment measurements
                                    # (IEN microneedle PCB, stimulation data)
```

## Dependencies

**MATLAB** (R2022a or later):
- Signal Processing Toolbox
- Control System Toolbox (ME4056, ME6407)
- Statistics and Machine Learning Toolbox (ME6105)
- Robotics System Toolbox (ME6407)

**Python** (ME8813 — conda env `me8813`):
```bash
conda activate me8813
# Python 3.10 + numpy, pandas, scikit-learn, pgmpy, tensorflow, matplotlib
```
