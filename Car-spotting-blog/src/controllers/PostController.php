<?php
require_once '../models/post.php';
require_once '../views/PostAddView.php';
require_once '../views/RedirectView.php';
require_once '../views/PostListView.php';
require_once '../functions/addwatermark.php';

class PostController 
{
    public function new()
    {
        return new PostAddView();
    }
    
    public function add()
    {
        $title = $_POST['title'];
        $author = $_POST['author'];
        $watermark = $_POST['watermark'];
        
        $file = $_FILES['file'];
        
        $fileName = $file["name"];
        $fileType = $file["type"];
        $fileTempName = $file["tmp_name"];
        $fileError = $file["error"];
        $fileSize = $file["size"];
        
        $fileExtension = explode(".", $fileName);
        $fileActualExtension = strtolower(end($fileExtension));
        $allowedExtensions = array("jpg","png");
                                          
                                          
        if(!in_array($fileActualExtension, $allowedExtensions))
        {
            return new RedirectView('/addnewposts/wrongExtensionOfFile',404);
        }
        else
        {
            if($fileError !== 0)
            {
                return new RedirectView('/addnewposts/errorWhileDownloadingFile',404);
            }
            else
            {
                if($fileSize > 1000000)
                {
                    return new RedirectView('/addnewposts/fileIsTooBig',404);
                }
                else
                {
                    $imageFullName = uniqid('', true).".".$fileActualExtension;
                    $fileDestination = "images/orginal/".$imageFullName;
                    move_uploaded_file($fileTempName, $fileDestination);
                    $watermarking = new addwatermark($imageFullName,$watermark);
                    $watermarking->createwatermark();
                }
            }
        }             
        $post = new Post($title, $author, $imageFullName);
        $post->save();
        return new RedirectView('/posts',303);
    }
    
    public function index()
    {
        $posts = Post::getAll();
        $pages = Post::getPages();
        return new PostListView($posts, $pages);
    }
}