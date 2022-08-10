import { SQSEvent } from "aws-lambda"
import { SNSClient, PublishCommand } from "@aws-sdk/client-sns"

const REGION = "eu-west-1"
const client = new SNSClient({region: REGION})

type apiInput = {
    message: string
    phoneNumber: string
}

export const handler = async (event: SQSEvent): Promise<void> => {
    const body: apiInput = JSON.parse(event.Records[0].body)
    console.log(JSON.stringify(body))

    try {
        await client.send(new PublishCommand({
            PhoneNumber: body.phoneNumber,
            Message: body.message
        }))
    } catch (e) {
        console.log(e)
    }
}