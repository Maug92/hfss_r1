% Toolbox Dependencies: Computer Vision Toolbox
classdef lens_distortion
   properties
       camera_params;
   end
   
   methods
       function obj = lens_distortion(obj, camera_params)
           obj.camera_params = camera_params;
       end
       
       function corrected_img = correct(distorted_img)
           corrected_img = undistortImg(distorted_img);
       end
   end   
end