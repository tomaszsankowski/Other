
#include <stdio.h>
using namespace std;

#include <iostream>

// OpenCV includes
#include <opencv2/opencv.hpp>
using namespace cv;

Mat srcImage; // input (source) image
Mat greyImage; 
int threshold_value = 100;
int max_value = 255;
Mat binarizedImage;

void Threshold(int pos, void* userdata)
{
	threshold(greyImage, binarizedImage, threshold_value, max_value, THRESH_BINARY);
	imshow("Binarization", binarizedImage);

}
void CreateWindowAt(const char* name, int x, int y)
{
	namedWindow(name, WINDOW_AUTOSIZE);
	moveWindow(name, x, y);
}

void ShowImageAt(Mat img, const char* name, int x, int y)
{
	CreateWindowAt(name, x, y);
	imshow(name, img);
}

void Brightness(Mat src, Mat dst, int B)
{
	for (int i = 0; i < src.cols; i++) {
		for (int j = 0; j < src.rows; j++)
		{
			Vec3b pixelColor;
			pixelColor = src.at<Vec3b>(i, j);
			for (int i = 0; i < 3; i++)
			{
				int tmp = B;
				tmp += (int)pixelColor[i];
				if (tmp <= 255)
					pixelColor[i] += B;
				else
					pixelColor[i] = 255;
			}

			dst.at<Vec3b>(i, j) = pixelColor;
		}
	}
}

void DrawHistogramAt(Mat src, const char* name, int x, int y)
{
	int histSize = 256;
	int hist_w = 256;
	int hist_h = 256;
	float range[2] = { 0,256 };
	const float* histRange = { range };
	Mat histogram;
	calcHist(&src, 1, 0, Mat(), histogram, 1, &histSize, &histRange);
	normalize(histogram, histogram, range[0], range[1], NORM_MINMAX);
	Mat histImage(hist_h, hist_w, CV_8UC3, Scalar(0, 0, 0));
	for (int i = 0; i < histSize; i++)
	{
		int tmp = cvRound(histogram.at<float>(i));
		line(histImage, Point(i, hist_h - 1), Point(i, hist_w - tmp), Scalar(255, 0, 0), 1);
	}

	ShowImageAt(histImage, name, x, y);
}


int main()\
{
	// reading source file srcImage
	srcImage = imread("Samples/Fish.jpg");
	if (!srcImage.data)
	{
		cout << "Error! Cannot read source file. Press ENTER.";
		waitKey(); // wait for a key press
		return(-1);
	}

	ShowImageAt(srcImage, "Sankowski Tomasz", 0, 0);

	cvtColor(srcImage, greyImage, COLOR_BGR2GRAY);
	ShowImageAt(greyImage, "Gray image", 300, 0);
	imwrite("Samples/Gray image.jpg", greyImage);

	Mat resizedImage(150, 150, srcImage.type());
	resize(srcImage, resizedImage, Size(150, 150));
	ShowImageAt(resizedImage, "Small", 600, 0);

	Mat blurImage;
	blur(srcImage, blurImage, Size(5, 5));
	ShowImageAt(blurImage, "Blurred image", 900, 0);

	Mat CannyImage;
	Canny(srcImage, CannyImage, 100, 100);
	ShowImageAt(CannyImage, "Canny filter", 1200, 0);

	Mat LaplacianImage;
	Laplacian(greyImage, LaplacianImage, CV_16S, 3);

	Mat scaledLaplacianImage;
	convertScaleAbs(LaplacianImage, scaledLaplacianImage, 1.5, 1.5);
	ShowImageAt(scaledLaplacianImage, "LaplacianImage", 1500, 0);

	Mat dilatedImage, erodedImage;
	int iterations = 2;
	Mat element = getStructuringElement(MORPH_RECT, Size(iterations * 2 + 1, iterations * 2 + 1), Point(iterations, iterations));
	dilate(CannyImage, dilatedImage, element);
	ShowImageAt(dilatedImage, "Dilated Image", 1200, 300);
	erode(dilatedImage, erodedImage, element);
	ShowImageAt(erodedImage, "Eroded Image", 1500, 300);

	Mat brightImage;
	srcImage.copyTo(brightImage);
	Brightness(brightImage, brightImage, 100);
	ShowImageAt(brightImage, "Bright Image", 0, 300);

	CreateWindowAt("Binarization", 300, 600);
	createTrackbar("Threshold value", "Binarization", &threshold_value, max_value, Threshold);
	Threshold(threshold_value, NULL);

	DrawHistogramAt(greyImage, "Gray image histogram", 300, 300);

	Mat equalizedImage;
	equalizeHist(greyImage, equalizedImage);
	ShowImageAt(equalizedImage, "Equalized image histogram Image", 600, 300);
	DrawHistogramAt(equalizedImage, "Histogram Equalized", 900, 300);

	waitKey();

	CreateWindowAt("Src video", 600, 600);
	CreateWindowAt("Dst video", 1200, 600);
	Mat srcFrame, dstFrame;
	VideoCapture capture("Samples/Dino.avi");
	capture >> srcFrame;
	VideoWriter writer("Samples/Dino2.avi", -1, 25, srcFrame.size());

	int zmienna = 0;
	while (!srcFrame.empty())
	{

		capture >> srcFrame;
		zmienna = waitKey(40);
		blur(srcFrame, dstFrame, Size(5,5));
		writer << dstFrame;
		imshow("Src video", srcFrame);
		imshow("Dst video", dstFrame);
		if (zmienna == 27)
			break;
	}

}
