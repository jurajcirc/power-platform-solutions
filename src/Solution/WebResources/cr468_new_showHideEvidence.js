window.showHideTabsByStage = function (executionContext) {
    var formContext = executionContext.getFormContext();

    function updateVisibility() {
        var process = formContext.data.process;
        var activeStage = process ? process.getActiveStage() : null;
        var stageName = activeStage ? activeStage.getName() : "";

        console.log(">>> Current BPF stage:", stageName);

        // Hide all tabs
        formContext.ui.tabs.forEach(function (tab) {
            tab.setVisible(false);
        });

        if (stageName === "Discrepancy Info") {
            showTabByName("General");
            console.log("-> Showing only tab: General");
        } else if (stageName === "Attach Evidence") {
            showTabByName("Evidence");
            console.log("-> Showing only tab: Evidence");
        } else if (stageName === "Close Discrepancy") {
            showTabByName("General");
            showTabByName("Evidence");
            showTabByName("Corrective");
            console.log("-> Showing tabs: General, Evidence, Corrective");
        }
    }

    function showTabByName(tabName) {
        var tab = formContext.ui.tabs.get(tabName);
        if (tab) {
            tab.setVisible(true);
        }
    }

    updateVisibility();

    formContext.ui.addOnLoad(updateVisibility);
    if (formContext.data.process) {
        formContext.data.process.addOnStageSelected(updateVisibility);
        formContext.data.process.addOnStageChange(updateVisibility);
    }
    formContext.data.entity.addOnSave(updateVisibility);
};
