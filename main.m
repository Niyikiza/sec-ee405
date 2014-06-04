while 1
    acc=ee405(s,'acc');
    acc=acc/32*1.5;	% convert to g value (32 means 1.5g)
    if acc(2) < 0.5 || acc(3) > 0.5
        pause(2);
        fprintf(s,'say("card.wav")');
        a = vcapg2([0 1], 30);
        
        cnt = 0;
        check = 0;
        while 1
            [a1 a2] = vcapg2;
            
            y1 = 60;
            y2 = 380;
            x1 = 160;
            x2 = 480;
            f = double(a2)/255;
            f(y1:y1+1,x1:x2,:)=1;   % draw a white bounding box
            f(y2-1:y2,x1:x2,:)=1;
            f(y1:y2,x1:x1+1,:)=1;
            f(y1:y2,x2-1:x2,:)=1;
            image(f);
            drawnow
            if check == 0
                check = 1;
                tic
            end
            if toc > 5
                
                imwrite(f(y1:y2,x1:x2,:),'qrcode.png');
                [status, result] = dos(' python sender.py qrcode.png');
                if strcmp(result(1:length(result)-1), 'Approved by Group 11 of EE405') == 1
                    fprintf(s,'say("detected.wav")');
                    break;
                else
                    fprintf(s,'say("again.wav")');
                    cnt = cnt+1;
                    check = 0;
                end

                if cnt == 5
                    vidObject = VideoWriter('Camera.avi');   % Create a new AVI file
                    open(vidObject);

                    for iFrame = 1:500                    % Capture 500 frames
                        [a1 a2] = vcapg2;
                        F = im2frame(a1);                    % Convert I to a movie frame
                        writeVideo(vidObject,F);  % Add the frame to the AVI file
                    end
                    close(vidObject);
                    
                    system('google.exe< command.txt');
                    
                    break;
                end
            end
        end
        
        break;
    end       
end
