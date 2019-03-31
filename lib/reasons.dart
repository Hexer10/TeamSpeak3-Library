/// Constants to identify any 'reasonid' parameter.
library teamspeak3.reasons;

/// Either change channel or entered the server.
const join = 0;

/// User or channel moved.
const moved = 2;

/// User timed out.
const timedOut = 3;

/// User kicked from the channel.
const channelKick = 4;

/// User kicked from the server.
const serverKick = 5;

/// User banned from the server.
const ban = 6;

/// User disconnected from the server.
const disconnect = 8;

/// Server or channel edited.
const edited = 10;

/// Server shutdown.
const shutdown = 11;