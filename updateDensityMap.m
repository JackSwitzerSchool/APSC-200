% File: updateDensityMap.m

function densityMap = updateDensityMap(X, Y, points, time, speed_left, speed_top, speed_random)
    densityMap = zeros(size(X));

    % Calculate the distance traveled based on time and speed
    distance_traveled_left = time * speed_left;
    distance_traveled_top = time * speed_top;

    % Debug Statements
    disp(['Time: ', num2str(time)]);
    disp(['Distance Traveled (Left): ', num2str(distance_traveled_left)]);
    disp(['Distance Traveled (Top): ', num2str(distance_traveled_top)]);

    % Update density map for the left half (move upward)
    newY_left = Y - distance_traveled_left;
    left_half = (X <= numel(X)/2);
    densityMap(left_half) = exp(-((X(left_half) - numel(X)/4).^2 + (newY_left(left_half) - numel(Y)/2).^2) / (2 * 5^2));

    % Update density map for the top half (move rightward)
    newX_top = X + distance_traveled_top;
    top_half = (Y >= numel(Y)/2);
    densityMap(top_half) = densityMap(top_half) + exp(-((newX_top(top_half) - numel(X)/2).^2 + (Y(top_half) - numel(Y)).^2) / (2 * 5^2));

    % Update density map for random movement in the remaining areas
    remaining_area = ~(left_half | top_half);
    densityMap(remaining_area) = densityMap(remaining_area) + rand(size(X(remaining_area))) * speed_random;

    % Loop through points and update density map for random points
    for i = 1:size(points, 1)
        point = points(i, :);
        distances = sqrt((X - point(1)).^2 + (Y - point(2)).^2);
        densityMap = densityMap + exp(-distances.^2 / (2 * 5^2));
    end

    % Debug Statement
    disp(['Max Density: ', num2str(max(densityMap(:)))]);
end
