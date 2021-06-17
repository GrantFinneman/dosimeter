open("");
run("3D Project...", "projection=[Brightest Point] axis=Y-Axis slice=0 initial=0 total=360 rotation=10 lower=1 upper=255 opacity=0 surface=100 interior=50");
makeLine(102, 0, 102, 202);
run("Plot Profile");

