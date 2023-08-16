alias ScaffoldAptosBasedOnAI.SmartPrompterInteractor
endpoint = Constants.smart_prompter_endpoint()
SmartPrompterInteractor.set_session(endpoint)
title = "AskWhitepaper"
content = "Here are the informations from documentations: \n{content}\nSo the question is: {question}"
SmartPrompterInteractor.create_template(endpoint, title, content)