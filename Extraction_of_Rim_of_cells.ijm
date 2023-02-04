//選択した画像に対して、2回Erodeした画像と2回Dilateした画像をそれぞれ作製する
//作製した画像をもとにして、細胞の辺縁部だけを抽出する画像を作製する。

name = getTitle();
Dil_name = "Dilate_"+name;
Erode_name = "Erode_"+name;

selectWindow(name);
run("Duplicate...", "title=Dilate_img");
selectWindow("Dilate_img");
rename(Dil_name);
close("Dilate_img");


selectWindow(name);
run("Duplicate...", "title=Erode_img");
selectWindow("Erode_img");
rename(Erode_name);


selectWindow(Dil_name);
run("Dilate");
run("Dilate");

selectWindow(Erode_name);
run("Erode")
run("Erode")

imageCalculator("Difference create", Erode_name, Dil_name);
rim_name = "Rim_"+name;
rename(rim_name);



