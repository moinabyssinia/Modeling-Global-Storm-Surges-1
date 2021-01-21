basepath = 'F:\OneDrive - Knights - University of Central Florida\Daten\Remote Sensing\CCMP';
base_yr = datenum('1987-01-01 00:00:00');
list_yr = dir(basepath);
list_yr(1:2) = []; list_yr(end) = [];
for yy = 39:40%length(list_yr)
    cd(fullfile(basepath, list_yr(yy).name));
    list_mm = dir(pwd); 
    list_mm(1:2) = [];
    
    
    st = 1; Thour = []; Tu = []; Tv = []; u4xdaily = []; v4xdaily = [];
    for mm = 1:length(list_mm)
        cd(fullfile(pwd, list_mm(mm).name));
        list_dd = dir(pwd);
        list_dd(1:2) = [];
        list_dd(end) = [];
        
        for dd = 1:length(list_dd)
            if st == 1
                d = dd
            else
                d = d + 1
            end
            fname = list_dd(dd).name
            wind_u = ncread(fname, 'uwnd');
            wind_v = ncread(fname, 'vwnd');
            tt = ncread(fname, 'time');
            Lon = ncread(fname, 'longitude'); 
            Lat = ncread(fname, 'latitude');
            Thour = [Thour; datenum(hours(tt) + base_yr)]; %Concatenate timestamp rowwise
            u4xdaily = cat(3, u4xdaily, wind_u);
            v4xdaily = cat(3, v4xdaily, wind_v);
            st = 0;
      end
        cd('..')
        
    end
    cd (basepath);
    save_name1 = sprintf('%s_u4x_daily.mat', list_yr(yy).name);
    save_name2 = sprintf('%s_v4x_daily.mat', list_yr(yy).name);
    %mat_name = fullfile(basepath, save_name);
    save (save_name1, 'base_yr', 'list_yr', 'fname', 'Lon', 'Lat', 'Thour', 'u4xdaily','-v7.3');
    save (save_name2, 'base_yr', 'list_yr', 'fname', 'Lon', 'Lat', 'Thour', 'v4xdaily','-v7.3');
    if yy == length(list_yr)
        return;
    else
        clearvars wind_u wind_v udmax vdmax;
    end
    cd('..')
    
end

