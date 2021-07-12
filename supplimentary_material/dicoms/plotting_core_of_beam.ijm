open("");
//open("/home/gmf/Downloads/dicoms/6MV/1x3.dcm");
title = getTitle();
setSlice(136);
makeLine(102, 0, 102, 176);

run("Plot Profile");
// saveAs("Results",);
