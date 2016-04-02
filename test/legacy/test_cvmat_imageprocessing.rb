#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8 -*-
require 'test/unit'
require 'opencv'
require File.expand_path(File.dirname(__FILE__)) + '/../helper'

include Cv

# Tests for image processing functions of Cv::CvMat
module Legacy
  class TestCvMat_imageprocessing < OpenCVTestCase
    DEPTH = [:cv8u, :cv8s, :cv16u, :cv16s, :cv32s, :cv32f, :cv64f]

    def test_sobel
      mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)

      mat1 = mat0.sobel(1, 0).convert_scale_abs(:scale => 1, :shift => 0)
      mat2 = mat0.sobel(0, 1).convert_scale_abs(:scale => 1, :shift => 0)
      mat3 = mat0.sobel(1, 1).convert_scale_abs(:scale => 1, :shift => 0)
      mat4 = mat0.sobel(1, 1, 3).convert_scale_abs(:scale => 1, :shift => 0)
      mat5 = mat0.sobel(1, 1, 5).convert_scale_abs(:scale => 1, :shift => 0)

      assert_equal(:cv16s, CvMat.new(16, 16, :cv8u, 1).sobel(1, 1).depth)
      assert_equal(:cv32f, CvMat.new(16, 16, :cv32f, 1).sobel(1, 1).depth)

      (DEPTH - [:cv8u, :cv16u, :cv16s, :cv32f]).each { |depth|
        assert_raise(Cv::Error::StsNotImplemented) {
          CvMat.new(3, 3, depth).sobel(1, 1)
        }
      }

      assert_raise(TypeError) {
        mat0.sobel(DUMMY_OBJ, 0)
      }
      assert_raise(TypeError) {
        mat0.sobel(1, DUMMY_OBJ)
      }
      assert_raise(TypeError) {
        mat0.sobel(1, 0, DUMMY_OBJ)
      }
    end

    def test_laplace
      mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)

      mat1 = mat0.laplace.convert_scale_abs(:scale => 1, :shift => 0)
      mat2 = mat0.laplace(3).convert_scale_abs(:scale => 1, :shift => 0)
      mat3 = mat0.laplace(5).convert_scale_abs(:scale => 1, :shift => 0)

      assert_equal(:cv16s, CvMat.new(16, 16, :cv8u, 1).laplace.depth)
      assert_equal(:cv32f, CvMat.new(16, 16, :cv32f, 1).laplace.depth)

      (DEPTH - [:cv8u, :cv16u, :cv16s, :cv32f, :cv64f]).each { |depth|
        assert_raise(Cv::Error::StsNotImplemented) {
          CvMat.new(3, 3, depth).laplace
        }
      }
      assert_raise(Cv::Error::StsAssert) {
        CvMat.new(3, 3, :cv64f).laplace
      }

      assert_raise(TypeError) {
        mat0.laplace(DUMMY_OBJ)
      }
    end

    def test_canny
      mat0 = CvMat.load(FILENAME_LENA256x256, CV_LOAD_IMAGE_GRAYSCALE)
      mat1 = mat0.canny(50, 200)
      mat2 = mat0.canny(50, 200, 3)
      mat3 = mat0.canny(50, 200, 5)

      assert_raise(TypeError) {
        mat0.canny(DUMMY_OBJ, 200)
      }
      assert_raise(TypeError) {
        mat0.canny(50, DUMMY_OBJ)
      }
      assert_raise(TypeError) {
        mat0.canny(50, 200, DUMMY_OBJ)
      }
    end
  end
end
