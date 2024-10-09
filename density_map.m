function density_maps = density_map(x, y, D, nSteps)
    % Parameters
    gridSize = 786; % Size of the grid
    numPoints = 10000; % Number of random data points
    speed_mph = 5.6; % Movement speed in miles per hour
    bottomRightSpeed_mph = 4; % Movement speed in the bottom right quarter
    simulationTimeDays = 10; % Simulation time in days
    stepsPerDay = nSteps/simulationTimeDays;
    % Conversion factor: 24 hours in a day
    hoursInDay = 24;

    % Convert speeds to units/day
    speed = speed_mph / gridSize * hoursInDay;
    bottomRightSpeed = bottomRightSpeed_mph / gridSize * hoursInDay;

    % Generate random data points
    dataPoints = rand(numPoints, 2);

    % Create a 2D grid
    x = linspace(0, 1, gridSize);
    y = linspace(0, 1, gridSize);
    [X, Y] = meshgrid(x, y);
    d = meshgrid(x, y);
    
    % Initialize density map outside the simulation loop
    totalDensityMap = zeros(gridSize);

    % Initialize cell array to store density maps
    density_maps = cell(1, simulationTimeDays);

    % Simulation loop
    for t = 1:simulationTimeDays
        % Update density map based on existing data points
        densityMap = zeros(gridSize);

        for i = 1:size(dataPoints, 1)
            xIndex = find(abs(x - dataPoints(i, 1)) == min(abs(x - dataPoints(i, 1))));
            yIndex = find(abs(y - dataPoints(i, 2)) == min(abs(y - dataPoints(i, 2))));

            densityMap(yIndex, xIndex) = densityMap(yIndex, xIndex) + 1;

            % Update movement rules for existing points (unchanged)

            % Move points in the top third to the right
            if dataPoints(i, 2) >= 0.66 && dataPoints(i, 1) < 1
                dataPoints(i, 1) = min(dataPoints(i, 1) + speed, 1);
            end

            % Move points in the left half upwards and stop when y=1
            if dataPoints(i, 1) < 0.33 && dataPoints(i, 2) < 1
                dataPoints(i, 2) = min(dataPoints(i, 2) + speed, 1);
            end

            % Move points where y < 0.5 and x > 0.5 gradually over time
            if dataPoints(i, 2) < 0.66 && dataPoints(i, 1) >= 0.33
                % Move to the left
                dataPoints(i, 1) = max(dataPoints(i, 1) - rand() * (3*speed) * t / simulationTimeDays , 0);

                % Move upwards at a random speed less than 5.6
                dataPoints(i, 2) = min(dataPoints(i, 2) + rand() * (2*speed) * t / simulationTimeDays, 1);
            end
        end


    % Update density map based on new data points
    newPointsCount = 500;
    newPointsX = 0.6 + rand(newPointsCount, 1) * 0.4; % x >= 0.75
    newPointsY = rand(newPointsCount, 1) * 0.66;         % y < 0.66

    for i = 1:size(newPointsX, 1)
        xIndex = find(abs(x - newPointsX(i)) == min(abs(x - newPointsX(i))));
        yIndex = find(abs(y - newPointsY(i)) == min(abs(y - newPointsY(i))));
        
        densityMap(yIndex, xIndex) = densityMap(yIndex, xIndex) + 1;
    end

    % Update density map based on thrown garbage
    newPointsCount1 = 25;
    newPoints1X = 0.0 + rand(newPointsCount1, 1) * 0.1; % x >= 0.75
    newPoints1Y = rand(newPointsCount1, 1) ;         % y < 0.66

    for i = 1:size(newPoints1X, 1)
        xIndex = find(abs(x - newPoints1X(i)) == min(abs(x - newPoints1X(i))));
        yIndex = find(abs(y - newPoints1Y(i)) == min(abs(y - newPoints1Y(i))));
        
        densityMap(yIndex, xIndex) = densityMap(yIndex, xIndex) + 1;
    end
    % Update density map based on thrown garbage
    newPoints2X = rand(newPointsCount1, 1) ; % x >= 0.75
    newPoints2Y = 0.9+ rand(newPointsCount1, 1) *0.1 ;         % y < 0.66

    for i = 1:size(newPoints2X, 1)
        xIndex = find(abs(x - newPoints2X(i)) == min(abs(x - newPoints2X(i))));
        yIndex = find(abs(y - newPoints2Y(i)) == min(abs(y - newPoints2Y(i))));
        
        densityMap(yIndex, xIndex) = densityMap(yIndex, xIndex) + 1;
    end
     % Update density map based on thrown garbage
    newPoints3X = rand(newPointsCount1, 1) ; % x >= 0.75
    newPoints3Y = 00+ rand(newPointsCount1, 1) *0.1 ;         % y < 0.66

    for i = 1:size(newPoints3X, 1)
        xIndex = find(abs(x - newPoints3X(i)) == min(abs(x - newPoints3X(i))));
        yIndex = find(abs(y - newPoints3Y(i)) == min(abs(y - newPoints3Y(i))));
        
        densityMap(yIndex, xIndex) = densityMap(yIndex, xIndex) + 1;
    end

    % Concatenate the new points with the existing data points
        dataPoints = [dataPoints; [newPointsX, newPointsY]];
        dataPoints = [dataPoints; [newPoints1X, newPoints1Y]];
        dataPoints = [dataPoints; [newPoints2X, newPoints2Y]];
        dataPoints = [dataPoints; [newPoints3X, newPoints3Y]];

        % Accumulate density over days
        totalDensityMap = totalDensityMap + densityMap;

        % Normalize the total density map
        totalDensityMap = totalDensityMap / max(totalDensityMap(:));

        % Set a threshold value (adjust as needed)
        threshold = 0.5;

        % Threshold the density map to make it binary
        binaryDensityMap = densityMap > threshold;

        % Store the binary density map in the cell array
        tDay = t*stepsPerDay;
        for step=tDay-(stepsPerDay-1):tDay
            density_maps{step} = binaryDensityMap;
        end
    end
end