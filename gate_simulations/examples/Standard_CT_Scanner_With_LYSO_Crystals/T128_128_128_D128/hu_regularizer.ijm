run("MetaImage Reader ...", "open=/home/gmf/Projects/Proton_Imager/Project_Data/cubic_tumor_collections/128_128_128_cubic_tumors/tumor_128_128_128_149.mha use_virtual_stack");
run("Statistics");
saveAs("Results", "Results.csv");
run("Quit");
