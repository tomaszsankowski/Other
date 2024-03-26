<?php

class PostListView
{
    private $posts;
    private $pages;
    public function __construct($posts,$pages)
    {
         $this->posts = $posts;
         $this->pages = $pages;
    }
    
    public function render()
    {
        $posts = $this->posts;
        $pages = $this->pages;
        include '../web/galeria.php';
    }
}