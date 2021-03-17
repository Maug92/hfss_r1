classdef dark_current
    properties
        darkframe_map containers.Map {all_equal_sized_arrays(darkframe_map, ...
            'DarkFrameErr:ArraySizeMismatch', ...
            'Darkframes must all be of equal size.')}
    end
    
    methods (Access = public)
        function obj = dark_current(darkframe_map)
        %{ 
            Constructor 
                Args:
                    darkframe_map (containers.Map): A key/value map of 
                        exposure time (int)/darkframe (array) pairs
        %}
            obj.darkframe_map = darkframe_map;            
        end
        
        function corrected_img_array = subtract_darkframe(obj, noisy_img_array, ref_exposure_time)
        %{ 
            Method for subtracting darkframe with corresponding exposure time to target image 
        %}
            % find nearest exposure time available in darkframe_map
            nearest_exp_time = obj.find_nearest_exposure_time_key(ref_exposure_time);
            
            % subtract darkframe from noisy image
            corrected_img_array = noisy_img_array - obj.darkframe_map(nearest_exp_time);
        end        
    end
    
    methods (Access = private)
        function exposure_time_key = find_nearest_exposure_time_key(obj, ref_exposure_time)
        %{
            Used to identify most appropriate darkframe to use based on the
            nearest exposure time value.
        %}
            % get available exposure times
            exp_times = cell2mat(obj.darkframe_map.keys());
            
            % get nearest exposure time to the requested value
            [ ~, idx] = min(abs(exp_times - ref_exposure_time));
                        
            exposure_time_key = exp_times(idx);
        end
    end
end


% Validators
function all_equal_sized_arrays(map_of_arrays, eid_type, msg_type)
    arrays = map_of_arrays.values();
    
    compare_size = size(arrays(1));
    for i = 1:length(arrays)
        if size(arrays(i)) ~= compare_size                        
            throwAsCaller(MException(eid_type,msg_type))
        else
            compare_size = size(arrays(i));
        end
    end
end