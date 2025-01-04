Please refer to the code folder for the full code of MABH-DMOEA. Since the dynamic multi-objective optimization framework implemented by the native platEMO has some minor bugs, some fine-tuning was done in the underlying population update step, but it does not affect the final result of the algorithm. The adjusted platEMO and MABH-DMOEA are saved in the zip file, which also contains the specific design of the ablation experiment.

If you find our algorithm helpful, please cite:
Hu, Xiaolin, et al. "Hybrid response dynamic multi-objective optimization algorithm based on multi-arm bandit model." Information Sciences 681 (2024): 121192.



2024\10\30 update: The previous uniform_change_response.m file has been modified because of a bug in the format adjustment.

Run platemo and click test module or experiment module .
If you get an error when clicking test module, please ignore it because the zip file I uploaded only contains my own algorithm and all other algorithms have been deleted.
