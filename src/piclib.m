function outPara=piclib(funName,inPara)
switch(funName)
    case 'pic_split_preview'
        outPara=pic_split_preview(inPara);
    case 'pic_split'
        outPara=pic_split(inPara);
    otherwise
        outPara=disp('piclib Unknown method.');        
end
end

function outPara=pic_split_preview(inPara)
    disp('pic_split_preview');
    %原始数据
    srcData=imread(inPara.srcFile);
    [m,n,~]=size(srcData);
    topEdgeVal=max(0,inPara.topEdgeVal);
    buttonEdgeVal=max(0,inPara.buttonEdgeVal);
    leftEdgeVal=max(0,inPara.leftEdgeVal);
    rightEdgeVal=max(0,inPara.rightEdgeVal);
    rowNumsVal=max(1,inPara.rowNumsVal);
    colNumsVal=max(1,inPara.colNumsVal);
    rowEdgeVal=max(1,inPara.rowEdgeVal);
    colEdgeVal=max(1,inPara.colEdgeVal);
    %边缘重新计算
    topEdgeVal=topEdgeVal-rowEdgeVal/2;
    buttonEdgeVal=buttonEdgeVal-rowEdgeVal/2;
    leftEdgeVal=leftEdgeVal-colEdgeVal/2;
    rightEdgeVal=rightEdgeVal-colEdgeVal/2;    
    %窗口计算
    wind=ones(m,n)*0.6;
    mstep=(m-topEdgeVal-buttonEdgeVal)/rowNumsVal;
    nstep=(n-leftEdgeVal-rightEdgeVal)/colNumsVal;
    for i=0:rowNumsVal-1
        for j=0:colNumsVal-1
            wind(...
                ceil(max(topEdgeVal+mstep*i+rowEdgeVal/2,1)):...
                ceil(topEdgeVal+mstep*(i+1)-rowEdgeVal/2),...
                ceil(max(leftEdgeVal+nstep*j+colEdgeVal/2,1)):...
                ceil(leftEdgeVal+nstep*(j+1)-colEdgeVal/2),...
                :)=1;
        end
    end
    %合并
    outPara=uint8(double(srcData).*double(wind));
end
function outPara=pic_split(inPara)
    disp('pic_split');
    %原始数据
    srcData=imread(inPara.srcFile);
    [m,n,~]=size(srcData);
    topEdgeVal=max(0,inPara.topEdgeVal);
    buttonEdgeVal=max(0,inPara.buttonEdgeVal);
    leftEdgeVal=max(0,inPara.leftEdgeVal);
    rightEdgeVal=max(0,inPara.rightEdgeVal);
    rowNumsVal=max(1,inPara.rowNumsVal);
    colNumsVal=max(1,inPara.colNumsVal);
    rowEdgeVal=max(1,inPara.rowEdgeVal);
    colEdgeVal=max(1,inPara.colEdgeVal);
    %边缘重新计算
    topEdgeVal=topEdgeVal-rowEdgeVal/2;
    buttonEdgeVal=buttonEdgeVal-rowEdgeVal/2;
    leftEdgeVal=leftEdgeVal-colEdgeVal/2;
    rightEdgeVal=rightEdgeVal-colEdgeVal/2;    
    %窗口计算
    mstep=(m-topEdgeVal-buttonEdgeVal)/rowNumsVal;
    nstep=(n-leftEdgeVal-rightEdgeVal)/colNumsVal;
    srcFileName=regexp(inPara.srcFile, '\\', 'split');
    fmt=regexp(char(srcFileName(end)), '\.', 'split');
    for i=0:rowNumsVal-1
        for j=0:colNumsVal-1
            dstFileFullPath=sprintf('%s%s%d.%s',inPara.dstFilePath,char(fmt(1)),i*rowNumsVal+j,char(fmt(2)));
            imwrite(srcData(...
                ceil(max(topEdgeVal+mstep*i+rowEdgeVal/2,1)):...
                ceil(topEdgeVal+mstep*(i+1)-rowEdgeVal/2),...
                ceil(max(leftEdgeVal+nstep*j+colEdgeVal/2,1)):...
                ceil(leftEdgeVal+nstep*(j+1)-colEdgeVal/2),...
                :),...
                dstFileFullPath);
        end
    end
    outPara=0;
end
