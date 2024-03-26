<?php

class addwatermark
{
    public $imageFullName;
    public $watermark;
    public function __construct($imageFullName, $watermark)
    {
        $this->imageFullName = $imageFullName;
        $this->watermark = $watermark;
    }
    public function createwatermark()
    {
        $imageNewName = "images/watermark/water".$this->imageFullName;
        $imageMiniatureName = "images/miniatures/mini".$this->imageFullName;
        
        $fileExtension = explode(".", $this->imageFullName);
        $fileActualExtension = strtolower(end($fileExtension));
        if($fileActualExtension == "png"){
            $newimage = imagecreatefrompng("../web/images/orginal/".$this->imageFullName);
        }
        else{
            $newimage = imagecreatefromjpeg("../web/images/orginal/".$this->imageFullName);
        }
        
        $textColor = imagecolorallocate($newimage,255,255,255);
        $textFont = 'fonts/arial.ttf';
        $x = imagesx($newimage)/2;
        $y = imagesy($newimage)/2;
        imagettftext($newimage, 30, 7, $x, $y , $textColor, $textFont, $this->watermark);
        if($fileActualExtension == "png"){
            imagepng($newimage, $imageNewName);
        }
        else{
            imagejpeg($newimage,$imageNewName);
        }
        
        $sizeofimage = getimagesize("../web/images/orginal/".$this->imageFullName);
        $width = $sizeofimage[0];
        $height = $sizeofimage[1];
        
        $tmpimage = imagecreatetruecolor(200, 125);
        imagecopyresampled($tmpimage, $newimage, 0, 0, 0, 0, 200, 150, $width, $height);
        
        if($fileActualExtension == "png"){
            imagepng($tmpimage, $imageMiniatureName);
        }
        else{
            imagejpeg($tmpimage,$imageMiniatureName);
        }
    }
}