an_detect = conv(abs(audio),h);

    [bin_counts, bin_edges] = histcounts(an_detect,15);
    [~, peak_pos] = findpeaks(bin_counts);
    if(length(peak_pos) < 2)
        message = "ERROR: Couldn't detect trigger value...";
        return;
    end
    [~,trigger_pos] = min(bin_counts(peak_pos(1):peak_pos(end)));
    trigger = mean(bin_edges(trigger_pos:(trigger_pos+1)));

    dg_detect = (an_detect > trigger);


    