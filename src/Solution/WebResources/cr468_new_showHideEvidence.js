function showHideTabsByStage(executionContext) {
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

        // Show specific tab based on stage
        if (stageName === "Discrepancy Info") {
            showTabByName("General");
            console.log("-> Showing only tab: General");
        } else if (stageName === "Attach Evidence") {
            showTabByName("Evidence");
            console.log("-> Showing only tab: Evidence");
        } else if (stageName === "Close Discrepancy") {
            showTabByName("Corrective");
            console.log("-> Showing only tab: Corrective");
        }
    }

    function showTabByName(tabName) {
        var tab = formContext.ui.tabs.get(tabName);
        if (tab) {
            tab.setVisible(true);
        }
    }

    // Run once on load
    updateVisibility();

    // Attach to the UI's OnLoad so it runs after subgrid forms close
    formContext.ui.addOnLoad(updateVisibility);

    // Also stay hooked to process changes
    if (formContext.data.process) {
        formContext.data.process.addOnStageSelected(updateVisibility);
        formContext.data.process.addOnStageChange(updateVisibility);
    }

    // And on save
    formContext.data.entity.addOnSave(updateVisibility);

    // ❌ Removed: formContext.data.addOnRefresh(updateVisibility);
}
