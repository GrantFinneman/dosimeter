run("MetaImage Reader ...", "open=/home/gmf/Projects/Proton_Imager/Project_Data/cubic_tumor_collections/28_28_28_C_tumors/tumor_28_28_28_0017.mha use_virtual_stack");
run("Statistics");
saveAs("Results", "Results.csv");
run("Quit");
