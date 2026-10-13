import { Button, LabeledList, NumberInput, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  container: string | null;
  hasContainer: boolean;
  volume: number;
  capacity: number;
  target: string | null;
  rate: number;
};

export const GS13FeedingTube = () => {
  const { act, data } = useBackend<Data>();
  return (
    <Window width={380} height={260}>
      <Window.Content>
        <Section title="Feeding tube">
          <LabeledList>
            <LabeledList.Item label="Container">{data.container || 'None loaded'}</LabeledList.Item>
            <LabeledList.Item label="Contents">
              {data.volume.toFixed(1)} / {data.capacity} units
            </LabeledList.Item>
            <LabeledList.Item label="Recipient">{data.target || 'Drag the machine onto a recipient'}</LabeledList.Item>
            <LabeledList.Item label="Flow rate">
              <NumberInput
                value={data.rate}
                minValue={0}
                maxValue={5}
                step={0.01}
                unit="u/s"
                onChange={(value) => act('rate', { rate: value })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Stack>
          <Stack.Item>
            <Button icon={data.rate ? 'pause' : 'play'} onClick={() => act('pause')}>
              {data.rate ? 'Pause' : 'Resume'}
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="unlink" disabled={!data.target} onClick={() => act('detach')}>
              Disconnect
            </Button>
          </Stack.Item>
          <Stack.Item>
            <Button icon="eject" disabled={!data.hasContainer} onClick={() => act('eject')}>
              Eject
            </Button>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
