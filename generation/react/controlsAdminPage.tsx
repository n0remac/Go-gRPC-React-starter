import React, { useState } from 'react';
import { controlsService } from '../../service';
import { 
    CreateControlsRequest, 
    GetControlsRequest, 
    UpdateControlsRequest, 
    DeleteControlsRequest, 
    Controls 
} from '../../rpc/proto/controls/controls_pb';

const ControlsPage = () => {
    const [controls, setControls] = useState(new Controls());
    const [searchId, setSearchId] = useState<string>('');
    const [searchResult, setSearchResult] = useState<Controls | null>(null);
    const [status, setStatus] = useState<string>('');

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const { name, value } = e.target;
        const parsedValue = name === "id" || name === "id" || name === "forward" || name === "backward" || name === "left" || name === "right" || name === "speed" ? parseInt(value, 10) : value;
        setControls(prevControls => {
            const updatedControls = { ...prevControls } as Controls;
            (updatedControls as any)[name] = parsedValue;
            return updatedControls;
        });
    };

    const handleCreate = async (e: React.FormEvent) => {
        e.preventDefault();
        const request = new CreateControlsRequest();
        request.controls = new Controls();
        request.