function prepareClipboardTable() {
    var clipboardTable = $('#jira_issues_clipboard > tbody');
    clipboardTable.empty();
    $('#jira_issues > tbody > tr').each(function (i, row) {
        var key = $(row).children('.issue_key').html();
        var summary = $(row).children('.issue_summary').html();
        clipboardTable.append('<tr><td nowrap>' + key + '</td><td>' + summary + '</td></tr>');
    });
}

function setTooltip(btn, message) {
    $(btn).tooltip('hide')
        .attr('data-original-title', message)
        .tooltip('show');
}

function hideTooltip(btn) {
    setTimeout(function() {
        $(btn).tooltip('hide');
    }, 1000);
}

$(document).on('turbolinks:load', function() {
    var clipboard = new Clipboard('#copy-btn', {
        target: function (trigger) {
            prepareClipboardTable();
            return $('#jira_issues_clipboard')[0];
        }
    });

    if(clipboard) {
        clipboard.on('success', function(e) {
            setTooltip(e.trigger, 'Copied!');
            hideTooltip(e.trigger);
        });

        clipboard.on('error', function(e) {
            setTooltip(e.trigger, 'Failed!');
            hideTooltip(e.trigger);
        });
    }

    $('#copy-btn').tooltip({
        trigger: 'click',
        placement: 'bottom'
    });
});
