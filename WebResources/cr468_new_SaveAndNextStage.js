function saveAndMoveNext(formContext) {
    console.log("Save & Next Stage clicked. Form context:", formContext);

    var process = formContext.data.process;
    var isReviewStage = false;
    var activeStage = null;

    if (process) {
        activeStage = process.getActiveStage();
        if (activeStage) {
            var stageName = activeStage.getName();
            console.log("Current stage on click:", stageName);
            if (stageName && stageName.trim() === "Review / Complete") {
                isReviewStage = true;
            }
        }
    }

    formContext.data.save().then(
        function success() {
            console.log("Record saved successfully.");
            if (process) {
                console.log("Attempting to move to next stage...");
                process.moveNext(function(result) {
                    console.log("Move to next stage result:", result);
                    // If we are in the Review stage, assume moveNext completes the process
                    if (isReviewStage) {
                        console.log("Likely final stage. Closing form.");
                        formContext.ui.close();
                    }
                });
            } else {
                console.log("No process available on form.");
                formContext.ui.close();
            }
        },
        function(error) {
            console.log("Save failed: " + error.message);
            formContext.ui.setFormNotification("Save failed: " + error.message, "ERROR", "save_error");
        }
    );
}

function autoCompleteBPFOnSave(executionContext) {
    var formContext = executionContext.getFormContext();
    var process = formContext.data.process;
    var activeStage = process.getActiveStage();

    if (activeStage && activeStage.getName() === "Review / Complete") {
        console.log("Auto-completing BPF final stage.");
        process.moveNext(function(result) {
            console.log("Process finalized: ", result);
        });
    }
}