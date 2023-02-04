//z-projectionした後にsplitして、RGB画像に変換後に指定のフォルダーに保存する

//Choice Save directory
saveDir = getDirectory("Choose a SAVE Directory");


original_name = getTitle;
dotIndex = indexOf(original_name, ".");
title = substring(original_name, 0, dotIndex)


run("Z Project...", "projection=[Max Intensity]");
run("Scale Bar...", "width=20 height=112 thickness=5 font=10 color=White background=None location=[Lower Right] horizontal bold overlay");
_name=getTitle;

run("Duplicate...", "title="+_name+"_marged duplicate");
separeted_name=getTitle;

run("Split Channels")

C1_name = "C1-"+separeted_name;
C2_name = "C2-"+separeted_name;
C3_name = "C3-"+separeted_name;

selectWindow(C1_name);
run("RGB Color");
newname = title+"_C1_"+"_RGB.tif"
rename(newname)
saveAs("tiff", saveDir+newname);
close(newname)

selectWindow(C2_name);
run("RGB Color");
newname = title+"_C2_"+"_RGB.tif"
rename(newname)
saveAs("tiff", saveDir+newname);
close(newname)

selectWindow(C3_name);
run("RGB Color");
newname = title+"_C3_"+"_RGB.tif"
rename(newname)
saveAs("tiff", saveDir+newname);
close(newname)

selectWindow(_name);
run("RGB Color");
newname = title+"_Marged_"+"_RGB.tif"
rename(newname)
saveAs("tiff", saveDir+newname);
close(newname)