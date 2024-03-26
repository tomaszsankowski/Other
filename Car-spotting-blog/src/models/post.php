<?php
require '../DataBase.php';

class Post
{
    public $title;
    public $author;
    private $_id;
    
    public function __construct($title, $author, $imageFullName)
    {
        $this->title = $title;
        $this->author = $author;
        $this->imageFullName = $imageFullName;
    }
    
    public function save()
    {
        $response = DataBase::get()->posts->insertOne([
            'title' => $this->title,
            'author' => $this->author,
            'imageFullName' => $this->imageFullName
        ]);
        $this->_id = $response->getInsertedId();
    }
    
    public static function getAll()
    {
        $paging = 4;
        
        if(isset($_GET["page"]))
        {
            $page = $_GET["page"];
        }
        else
        {
            $page = 1;
        }
        
        $options =[
            'skip' => ($page-1)*$paging,
            'limit' => $paging
        ];
        
        $response = DataBase::get()->posts->find([], $options);
        $posts = [];
        foreach ($response as $post)
        {
            $posts[] = new Post($post['title'],$post['author'],$post['imageFullName']);
        }
        
        return $posts; 
    }
    public static function  getPages()
    {
        $paging = 4;
        $response = DataBase::get()->posts->find([]);
        $tmp = [];
        foreach ($response as $post)
        {
            $tmp[] = new Post($post['title'],$post['author'],$post['imageFullName']);
        }
        $postNumber = count($tmp);
        $pages = ceil($postNumber/$paging);

        return $pages;
    }
}