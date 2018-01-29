function getMousePositionOnImage(src, event)

childs = get(src, 'Children');
loc = get(childs(2), 'CurrentPoint');

id = round(loc(1, 1));
dat = guidata(src);
dat.names{id}
files = dir(['../sounds/' dat.names{id} '*']);
[x, fs] = audioread(['../sounds/' files(1).name]);

stop(dat.ap);
ap = audioplayer(x, fs);
dat.ap=ap;
guidata(src, dat)
playblocking(ap);

% have to get the sorted list of file trough guidata


return

handles = guidata(src);

cursorPoint = get(handles.axesImage, 'CurrentPoint');
curX = cursorPoint(1,1);
curY = cursorPoint(1,2);

xLimits = get(handles.axes1, 'xlim');
yLimits = get(handles.axes1, 'ylim');

if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
disp(['Cursor coordinates are (' num2str(curX) ', ' num2str(curY) ').']);
else
disp('Cursor is outside bounds of image.');
end

end